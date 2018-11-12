#! /bin/sh
echo ${GOOGLE_AUTH} > ${HOME}/gcp-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
gcloud --quiet config set project ${GKE_PROJECT}
gcloud --quiet config set compute/zone ${GKE_ZONE}
gcloud --quiet config set container/cluster ${GKE_CLUSTER}
gcloud --quiet container clusters get-credentials ${GKE_CLUSTER}
