#### Build Static ####
FROM node:9-alpine as static-builder
MAINTAINER Konstantin Feofantov <kfeofantov@gmail.com>

WORKDIR /site
COPY . .

RUN rm -rf node_module
RUN npm cache clean --force
RUN npm install yarn
RUN yarn
RUN node node_modules/gulp/bin/gulp.js build

#### Build WEB ####
FROM alpine:3.6 as web-builder

ARG DOCS_VERSION
ARG DOCS_COMMIT

ENV DOCS_VERSION=$DOCS_VERSION \
    DOCS_COMMIT=$DOCS_COMMIT

COPY --from=static-builder /site /site
WORKDIR /site

ADD https://github.com/gohugoio/hugo/releases/download/v0.42.1/hugo_0.42.1_Linux-64bit.tar.gz /tmp/
RUN tar -zxf /tmp/hugo_0.42.1_Linux-64bit.tar.gz -C /bin

RUN /bin/hugo

#### Run Server ####
FROM nginx:1.12

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=web-builder /site/public/ /usr/share/nginx/html/
