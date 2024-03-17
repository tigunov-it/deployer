FROM alpine:3.19

ARG KUBECTL_VERSION=1.29.0

ENV KUBECTL_VERSION=$KUBECTL_VERSION

RUN apk --no-cache add \
        curl \
        bash \
        git \
        gnupg \
        aws-cli \
        openssl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2024-01-04/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

RUN helm plugin install https://github.com/futuresimple/helm-secrets

VOLUME ["/root/.config"]