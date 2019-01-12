#   Copyright 2018 NephoSolutions SPRL, Sebastian Trebitz
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

ARG ALPINE_VERSION
ARG ANSIBLE_VERSION

FROM alpine:${ALPINE_VERSION} as downloader

RUN apk add --no-cache --update \
      gnupg

WORKDIR /tmp

COPY hashicorp-releases-public-key.asc .
RUN gpg --import hashicorp-releases-public-key.asc

ARG PACKER_VERSION
ENV PACKER_VERSION ${PACKER_VERSION}

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip packer_${PACKER_VERSION}_linux_amd64.zip
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS.sig packer_${PACKER_VERSION}_SHA256SUMS.sig
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS packer_${PACKER_VERSION}_SHA256SUMS

RUN gpg --verify packer_${PACKER_VERSION}_SHA256SUMS.sig packer_${PACKER_VERSION}_SHA256SUMS

RUN grep linux_amd64 packer_${PACKER_VERSION}_SHA256SUMS > packer_${PACKER_VERSION}_SHA256SUMS_linux_amd64
RUN sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS_linux_amd64

WORKDIR /usr/local/bin

RUN unzip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip


FROM nephosolutions/ansible:${ANSIBLE_VERSION}
LABEL maintainer="sebastian@nephosolutions.com"

COPY --from=downloader /usr/local/bin/packer /usr/local/bin/packer
