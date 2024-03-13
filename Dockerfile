FROM alpine:3.19

ARG HELM_VERSION=3.14.2
ARG KUBEDOG_VERSION=v0.4.0

ENV KUBECTL_VERSION=$KUBECTL_VERSION
ENV HELM_VERSION=$HELM_VERSION
ENV HELM_HOME=/helm/
ENV YC_HOME=/yc

ENV PATH $HELM_HOME:$YC_HOME/bin:$PATH

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg

RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
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

RUN apk add --no-cache python3 py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install awscli \
    && rm -rf /var/cache/apk/*

RUN curl -L -o /usr/local/bin/kubedog https://tuf.kubedog.werf.io/targets/releases/${KUBEDOG_VERSION}/linux-amd64/bin/kubedog && \
    chmod +x /usr/local/bin/kubedog

VOLUME ["/root/.config"]