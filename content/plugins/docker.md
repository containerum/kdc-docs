# Docker 1.13.1 install:
```
$ sudo yum install docker
$ sudo sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
$ sudo systemctl daemon-reload
$ sudo systemctl start docker && sudo systemctl enable docker
