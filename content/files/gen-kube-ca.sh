#!/bin/bash
# version 1.3

set -o errexit
set -o errtrace
set -o functrace
set -o nounset
set -o pipefail

: ${KEYSZ_LONG:=4096}
: ${KEYSZ_SHORT:=2048}
: ${DAYS_LONG:=3653}
: ${DAYS_SHORT:=730}
: ${CA_CN:=Kubernetes Certificate Authority}
: ${CA_O:=Organization}
: ${CA_OU:=DevOps}

# wrapper function to print command and its arguments just before running it
V() {
	echo "$@"
	"$@"
	return $?
}

# basic RSA private key generator
gen_key() {
	local outfile="$1" keysz="$2"
	if [ "$#" -ne 2 ]; then
		echo >&2 "usage: gen_key outfile keysz"
		exit 2
	fi
	V openssl genrsa -out "$outfile" "$keysz"
	return $?
}

# generates certificate signing request from private key file and config file
gen_csr() {
	local outf="$1" keyf="$2" cfg="$3"
	if [ "$#" -ne 3 ]; then
		echo >&2 "usage: gen_csr outfile keyfile config"
		exit 2
	fi
	V openssl req -new -config "$cfg" -key "$keyf" -out "$outf"
	return $?
}

# certificate authority config file templator
gen_ca_conf() {
	local ret
	if [ "$#" -ne 1 ]; then
		echo >&2 "usage: gen_ca_conf outfile"
		exit 2
	fi
	cat <<-EOF > "$1"
	[req]
	encrypt_key = no
	default_md = sha256
	string_mask = utf8only
	req_extensions = kube_ca_exts
	prompt = no
	utf8 = yes
	distinguished_name = kube_ca_dn

	[kube_ca_exts]
	basicConstraints = critical, CA:true
	keyUsage = critical, keyCertSign, cRLSign
	subjectKeyIdentifier = critical, hash
	authorityKeyIdentifier = keyid:always

	[kube_ca_dn]
	CN = $CA_CN
	O = $CA_O
	OU = $CA_OU


	[ca]
	default_ca = kube_ca

	[kube_ca]
	new_certs_dir = ./ca/new_certs
	default_days = $DAYS_SHORT
	default_crl_days = 14
	default_md = sha256
	database = ./ca/database
	unique_subject = no
	serial = ./ca/serial
	crlnumber = ./ca/crlnumber
	x509_extensions = client_crt_exts
	crl_extensions = kube_ca_crl_exts
	policy = kube_ca_pol
	name_opt = ca_default
	cert_opt = ca_default
	copy_extensions = copy

	# for sub-CAs (probably not needed)
	#[sub_crt_exts]
	#basicConstraints = critical, CA:true, pathlen:0
	#keyUsage = critical, keyCertSign, cRLSign
	#subjectKeyIdentifier = hash
	#authorityKeyIdentifier = keyid:always

	[client_crt_exts]
	basicConstraints = critical, CA:false
	keyUsage = critical, digitalSignature, keyEncipherment, keyAgreement
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid:always

	[kube_ca_crl_exts]
	authorityKeyIdentifier = keyid:always

	[kube_ca_pol]
	CN = supplied
	O = optional
	L = optional
	C = optional
	OU = optional
	DC = optional
	ST = optional
	emailAddress = optional
	EOF
	ret=$?
	if [ "$ret" -ne 0 ]; then
		echo >&2 "gen_ca_conf: failed to write config file"
		exit 1
	fi
	return $ret
}

# utility function. bash analogue to python's "sep".join(args)
join_array() {
	local i sep="$1" args=() res=""
	shift
	args=("$@")
	for i in "${!args[@]}"; do
		if [ "$i" -lt $(( ${#args[@]} - 1 )) ]; then
			res+="${args[$i]}$sep"
		else
			res+="${args[$i]}"
		fi
	done
	echo "$res"
	return 0
}

# translates environment variable SAN with format like
#   '127.0.0.1 asdf.com 1.2.3.4 1.2.a.b.example.com'
# into a string acceptable for openssl config files:
#   "IP:127.0.0.1, DNS:asdf.com, IP:1.2.3.4, DNS:1.2.a.b.example.com"
translate_san() {
	local x res=()
	for x in $SAN; do
		if echo "$x" | egrep -q "^([0-9]+\.){3}[0-9]+$"; then
			res+=("IP:$x")
		else
			res+=("DNS:$x")
		fi
	done
	join_array ", " "${res[@]}"
}

# generates openssl config file for creating certificate signing requests
# of child certificates. which certificate fields to include in the CSR is
# specified on the argument list.
# for example, to generate a config for CSR with fields commonName (CN),
# organization (O), organization unit (OU) and country name (C), and
# subjectAltName (SAN), invoke:
#
#   export CN="my commonname"
#   export O="my org name"
#   export OU="my org unit"
#   export C="RU"
#   export SAN="rkn.gov.ru 81.177.103.94"
#   gen_conf nits.conf CN O OU C SAN
#
# respective environment variables must be present in the environment.
gen_conf() {
	local outf="$1" fields=() x san="" dn=""
	shift
	if [ "$#" -lt 1 ]; then
		echo >&2 "gen_conf: not enough data for cert request"
		exit 2
	fi

	for x in "$@"; do
		case "$x" in
		SAN)
			san="$(translate_san "$SAN")"
			;;
		CN|O|OU|C|ST|L)
			[ -n "$dn" ] && dn+=$'\n'
			dn+="$x = "
			x=$(eval "echo `echo \\$$x`")
			dn+="$x"
			;;
		*)
			echo >&2 "gen_conf: unexpected certificate field $x"
			exit 2
			;;
		esac
	done

	{
		echo "[req]"
		echo "default_md = sha256"
		echo "prompt = no"
		echo "utf8 = yes"
		if [ -n "$san" ]; then
			echo "req_extensions = req_exts"
		fi
		echo "distinguished_name = dn"
		echo
		echo "[dn]"
		echo "$dn"
		if [ -n "$san" ]; then
			echo
			echo "[req_exts]"
			echo "subjectAltName = $san"
		fi
	} > "$outf"
}

sign_csr() {
	local cacrt="$1" cakey="$2" csr="$3" crt="$4"
	if [ "$#" -ne 4 ]; then
		echo >&2 "usage: sign_csr ca_cert ca_key csr_in cert_out"
		exit 2
	fi

	local missing_file=""
	[ ! -s "$cacrt" ] && missing_file="$cacrt"
	[ ! -s "$cakey" ] && missing_file="$missing_file $cakey"
	[ ! -s "$csr" ] && missing_file="$missing_file $csr"
	if [ -n "$missing_file" ]; then
		echo >&2 "error: sign_csr: missing one of required files: ${missing_file# }"
		exit 1
	fi

	V openssl ca -config ca/ca.conf -cert "$cacrt" -keyfile "$cakey" -notext -batch -days "$DAYS_SHORT" -in "$csr" -out "$crt"
	return $?
}

main_init() {
	[ ! -s ca.key ] && \
		gen_key ca.key "$KEYSZ_LONG"

	[ -e ca -a ! -d ca ] && {
		echo >&2 "./ca must be a directory"
		exit 1
	}

	[ ! -d ca ] && \
		V mkdir ca

	[ ! -e ca/new_certs ] && \
		V mkdir ca/new_certs

	[ ! -d ca/new_certs ] && {
		echo >&2 "ca/new_certs must be a directory"
		exit 1
	}

	for f in ca/serial ca/crlnumber ca/database; do
		[ ! -e $f ] && V touch $f
		[ ! -f $f -o ! -r $f -o ! -w $f ] && {
			echo >&2 "$f must be a read-writable file"
			exit 1
		}
	done
	[ ! -s ca/serial ] && echo 01 > ca/serial
	[ ! -s ca/crlnumber ] && echo 01 > ca/crlnumber

	[ ! -s ca/ca.conf ] && \
		gen_ca_conf ca/ca.conf

	[ ! -s ca.crt ] && \
		V openssl req -new -x509 -config ca/ca.conf -key ca.key -out ca.crt -extensions kube_ca_exts -days "$DAYS_LONG"

	local basic_kube_certs=(admin kube-controller-manager kube-proxy kube-scheduler kubernetes service-account)

	for kcert in "${basic_kube_certs[@]}"; do
		if [ ! -e "$kcert.conf" ]; then
			case "$kcert" in
			kubernetes)
				[ -z "${SAN:-}" ] && echo >&2 "SAN env is empty, defaulting to '127.0.0.1 kubernetes.local'"
				CN=kubernetes O=Kubernetes SAN="${SAN:-127.0.0.1 kubernetes.local}" \
					gen_conf "$kcert.conf" CN O SAN
				;;
			admin)
				CN=admin O=system:masters \
					gen_conf "$kcert.conf" CN O
				;;
			kube-controller-manager)
				CN=system:kube-controller-manager O=system:kube-controller-manager \
					gen_conf "$kcert.conf" CN O
				;;
			kube-proxy)
				CN=system:kube-proxy O=system:node-proxier \
					gen_conf "$kcert.conf" CN O
				;;
			kube-scheduler)
				CN=system:kube-scheduler O=system:kube-scheduler \
					gen_conf "$kcert.conf" CN O
				;;
			service-account)
				CN=service-accounts O=Kubernetes \
					gen_conf "$kcert.conf" CN O
				;;
			esac
		fi
	done

	for kcert in "${basic_kube_certs[@]}"; do
		[ ! -s "$kcert.key" ] && gen_key "$kcert.key" "$KEYSZ_SHORT"
	done

	for kcert in "${basic_kube_certs[@]}"; do
		[ ! -s "$kcert.csr" ] && gen_csr "$kcert.csr" "$kcert.key" "$kcert.conf"
	done

	for kcert in "${basic_kube_certs[@]}"; do
		[ ! -s "$kcert.crt" ] && sign_csr ca.crt ca.key "$kcert.csr" "$kcert.crt"
	done

	return 0
}

prepare_conf() {
	[ $# -ne 1 ] && {
		echo >&2 "prepare_conf: invalid arguments"
		exit 2
	}

	[ ! -s "$1.key" ] && \
		gen_key "$1.key" "$KEYSZ_SHORT"
	[ ! -s "$1.conf" ] && {
		CN="${CN:-default_commonName}" O="${O:-default_organization}" SAN="${SAN:-127.0.0.1 localhost kubernetes.cluster}" \
			gen_conf "$1.conf" CN O SAN
	}
	return 0
}

prepare_csr() {
	[ $# -ne 1 ] && {
		echo >&2 "prepare_csr: invalid arguments"
		exit 2
	}

	prepare_conf "$1"
	[ ! -s "$1.csr" ] && \
		gen_csr "$1.csr" "$1.key" "$1.conf"

	return 0
}

sign_extra_csr() {
	[ $# -ne 1 ] && {
		echo >&2 "error: sign_extra_csr: invalid arguments"
		exit 2
	}

	[ ! -s "$1.csr" ] && {
		echo >&2 "error: sign_extra_csr: file $1.csr does not exist"
		exit 1
	}

	[ ! -s "$1.crt" ] && \
		sign_csr ca.crt ca.key "$1.csr" "$1.crt"

	return 0
}

print_help() {
	cat <<-EOF
	usage: $0 [ init | prepare cert_name.[conf|csr] | sign cert_name.crt ]

	This script helps generate and maintain certificate infrastructure sufficient
	to run a Kubernetes cluster.

	Arguments:

	   init                Initialize a CA and generate default set of certificates.
	   prepare file.conf   Prepare configuration for generating an extra CSR.
	   prepare file.csr    Generate an extra certificate signing request.
	   sign file.crt       Use CA to sign a CSR in file.csr. Result in file.crt.

	The script does not remove or overwrite any files with non-zero length - it
	completes the file structure to its full state by generating missing files from
	the files they are dependent on.

	For example, if you put files admin.key and ca.key into an empty directory, and
	call this script from there, it will use .key files provided by you for
	generation of the CA certificate and admin.csr (and consecutively admin.crt).
	If you want to re-issue a certificate from the same .csr, just remove its .crt
	file and rerun the script.

	The init subcommand uses IP addresses and DNS names from the environment
	variable SAN for the subjectAltName list in kubernetes.crt certificate.

	Similiarly, the prepare subcommand uses environment variables CN, O and SAN
	to fill in commonName, organization and subjectAltName fields in the CSR.

	EOF
	return 0
}

if [ "${1:-}" = "init" ]; then
	main_init
	exit 0
elif [ "${1:-}" = "prepare" ]; then
	shift
	if [ $# -eq 0 ]; then
		echo no arguments
		exit 0
	fi
	for x in "$@"; do
		if [[ ! "$x" = *.csr && ! "$x" = *.conf ]]; then
			echo >&2 "error: argument $x does not end in .csr or .conf"
			exit 2
		fi
	done
	for x in "$@"; do
		if [[ "$x" = *.conf ]]; then
			prepare_conf "${x%.conf}"
		elif [[ "$x" = *.csr ]]; then
			prepare_csr "${x%.csr}"
		fi
	done
elif [ "${1:-}" = "sign" ]; then
	shift
	if [ $# -eq 0 ]; then
		echo no arguments
		exit 0
	fi
	for x in "$@"; do
		if [[ ! "$x" = *.crt ]]; then
			echo >&2 "error: argument $x does not end in .crt"
			exit 2
		fi
	done
	for x in "$@"; do
		sign_extra_csr "${x%.crt}"
	done
elif [ "${1:-}" = "revoke" ]; then
	echo TODO
	exit 1
elif [ "${1:-}" = "nodes" ]; then
	echo TODO
	exit 1
elif [ "${1:-}" = "addnode" ]; then
	echo TODO
	exit 1
elif [ "${1:-}" = "--help" -o "${1:-}" = "-help" -o "${1:-}" = "-h" ]; then
	print_help
else
	print_help >&2
	exit 2
fi
