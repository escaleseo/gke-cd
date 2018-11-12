FROM docker:18.06 as static-docker-source
FROM google/cloud-sdk:224.0.0-alpine

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker

RUN mkdir /scripts
COPY gcloud-setup.sh /scripts

RUN apk add --update libintl gettext \
  && chmod +x /scripts/gcloud-setup.sh

ENV KUBE_LATEST_VERSION="v1.10.7"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*
