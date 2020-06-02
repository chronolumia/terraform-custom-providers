FROM golang:1.14.2 AS build


WORKDIR $GOPATH/src/github.com/terraform-providers

RUN apt update && apt install unzip && \
    curl -LOk https://github.com/infobloxopen/terraform-provider-infoblox/archive/v1.0.5.zip && \
    unzip v1.0.5.zip -d /tmp && \
    cd /tmp/terraform-provider-infoblox-1.0.5 && \
    make && \
    curl -LOk https://github.com/terraform-providers/terraform-provider-nsxt/archive/v2.0.0.zip && \
    unzip v2.0.0.zip -d $GOPATH/src/github.com/terraform-providers && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-nsxt-2.0.0 && \
    make && \
    mv /go/bin/terraform-provider-nsxt /go/bin/terraform-provider-nsxt_v2.0.0 && \
    curl -LOk https://github.com/terraform-providers/terraform-provider-nsxt/archive/v1.1.2.zip && \
    unzip v1.1.2.zip -d $GOPATH/src/github.com/terraform-providers && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-nsxt-1.1.2 && \
    make && \
    curl -LOk https://github.com/terraform-providers/terraform-provider-vsphere/archive/v1.18.2.zip && \
    unzip v1.18.2.zip -d $GOPATH/src/github.com/terraform-providers && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-vsphere-1.18.2 && \
    make && \
    mkdir -p $HOME/development/terraform-providers/ && \
    curl -LOk https://github.com/terraform-providers/terraform-provider-aws/archive/v2.63.0.zip && \
    unzip v2.63.0.zip -d $HOME/development/terraform-providers && \
    cd $HOME/development/terraform-providers/terraform-provider-aws-2.63.0 && \
    make tools && \
    make build && \
    chmod a+x /tmp/terraform-provider-infoblox-1.0.5/terraform-provider-infoblox && \
    chmod a+x /go/bin/terraform-provider-nsxt && \
    chmod a+x /go/bin/terraform-provider-vsphere && \
    chmod a+x /go/bin/terraform-provider-aws


FROM hashicorp/terraform:light

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/* && apk add --no-cache bash

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:usr/bin:/sbin:/bin

COPY --from=build /tmp/terraform-provider-infoblox-1.0.5/terraform-provider-infoblox /bin/terraform-provider-infoblox_v1.0.5
COPY --from=build /go/bin/terraform-provider-nsxt_v2.0.0 /bin/terraform-provider-nsxt_v2.0.0
COPY --from=build /go/bin/terraform-provider-nsxt /bin/terraform-provider-nsxt_v1.1.2
COPY --from=build /go/bin/terraform-provider-vsphere /bin/terraform-provider-vsphere_v1.18.2
COPY --from=build /go/bin/terraform-provider-aws /bin/terraform-provider-aws_v2.63.0

ENTRYPOINT ["/usr/bin/env"]