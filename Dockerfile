FROM hashicorp/packer:1.7.3 AS packer
LABEL maintainer="sebastian@nephosolutions.com"

RUN apk --no-cache add ansible libc6-compat make openssh-client rsync

RUN ln -s /lib /lib64

ADD https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub \
  /etc/apk/keys/sgerrand.rsa.pub

ADD https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk \
  /var/cache/apk/

RUN apk add /var/cache/apk/git-crypt-0.6.0-r1.apk

RUN addgroup packer && \
    adduser -G packer -D packer

USER packer
ENV USER packer
