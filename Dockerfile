FROM golang:1.14.2 AS build


WORKDIR $GOPATH/src/github.com/terraform-providers

RUN apt update && apt install unzip

RUN curl -LOk https://github.com/infobloxopen/terraform-provider-infoblox/archive/v1.0.5.zip && \
    unzip v1.0.5.zip -d /tmp && \
    cd /tmp/terraform-provider-infoblox-1.0.5 && \
    make && \
    chmod a+x /tmp/terraform-provider-infoblox-1.0.5/terraform-provider-infoblox


FROM hashicorp/terraform:light

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:usr/bin:/sbin:/bin

WORKDIR /terraform

COPY provider.tf /terraform

COPY --from=build /tmp/terraform-provider-infoblox-1.0.5/terraform-provider-infoblox /bin/terraform-provider-infoblox_v1.0.5_x4

RUN apk update && \
    apk add --no-cache bash ca-certificates

RUN terraform init && \
    cp -a /terraform/.terraform/plugins/linux_amd64/terraform-* /bin && \
    rm -rf /terraform/*


ENTRYPOINT ["/usr/bin/env"]