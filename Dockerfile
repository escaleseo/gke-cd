FROM docker:18.06 as static-docker-source
FROM google/cloud-sdk:224.0.0-alpine

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker

RUN apk add --update libintl gettext

RUN mkdir /scripts
COPY gcloud-setup.sh /scripts
RUN chmod +x /scripts/gcloud-setup.sh
