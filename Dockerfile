FROM golang:1.14.2 AS build


WORKDIR $GOPATH/src/github.com/terraform-providers

RUN apt update && apt install unzip

RUN go get github.com/estenrye/terraform-provider-s3 && \
    go install github.com/estenrye/terraform-provider-s3 && \
    cd $GOPATH/bin/ && \
    ls -la && \
    chmod a+x $GOPATH/bin/terraform-provider-s3

RUN curl -LOk https://github.com/terraform-providers/terraform-provider-nsxt/archive/master.zip && \
    unzip master.zip -d $GOPATH/src/github.com/terraform-providers && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-nsxt-master && \
    make && \
    chmod a+x $GOPATH/bin/terraform-provider-nsxt

FROM hashicorp/terraform:0.13.0-beta3

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:usr/bin:/sbin:/bin

WORKDIR /terraform

COPY provider.tf /terraform

COPY --from=build /go/bin/terraform-provider-s3 /bin/terraform-provider-s3_v1.0.12_x4
COPY --from=build /go/bin/terraform-provider-nsxt /bin/terraform-provider-nsxt_master_x4

RUN apk update && \
    apk add --no-cache bash curl jq ca-certificates

RUN terraform init && \
    #cp -a /terraform/.terraform/plugins/registry.terraform.io/terraform-providers/nsxt/2.1.1/linux_amd64/terraform-* /bin && \
    cp -a /terraform/.terraform/plugins/registry.terraform.io/terraform-providers/infoblox/1.0.0/linux_amd64/terraform-* /bin && \
    cp -a /terraform/.terraform/plugins/registry.terraform.io/hashicorp/vsphere/1.18.3/linux_amd64/terraform-* /bin && \
    cp -a /terraform/.terraform/plugins/registry.terraform.io/hashicorp/aws/2.63.0/linux_amd64/terraform-* /bin && \
    rm -rf /terraform/*


ENTRYPOINT ["/usr/bin/env"]