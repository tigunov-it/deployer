FROM alpine:3.19

ARG KUBECTL_VERSION=1.29.0
ARG HELM_VERSION=3.14.2
ARG KUBEDOG_VERSION=v0.4.0

ENV KUBECTL_VERSION=$KUBECTL_VERSION
ENV HELM_VERSION=$HELM_VERSION
ENV HELM_HOME=/helm/
ENV YC_HOME=/yc

ENV PATH $HELM_HOME:$YC_HOME/bin:$PATH

RUN apk --no-cache add \
        curl \
        python3 \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
        unzip

RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2024-01-04/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

RUN curl -O https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64 $HELM_HOME && \
    rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mkdir -p $HELM_HOME/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | \
    bash -s -- -i ${YC_HOME} -n

RUN curl -L -o /usr/local/bin/kubedog https://tuf.kubedog.werf.io/targets/releases/${KUBEDOG_VERSION}/linux-amd64/bin/kubedog && \
    chmod +x /usr/local/bin/kubedog

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws

VOLUME ["/root/.config"]