# Continuous Deployment for Google Kubernetes Engine

This image packs what is typically necessary for deploying services to Google Kubernetes Engine.


## Example Circle CI configuration

```yaml
version: 2
jobs:
  build:
    docker:
      - image: circleci/node:8
    steps:
      - checkout
      - run: npm install
      - run: npm run build
      - run:
          name: Move files to workspace
          command: 'set -exu && mkdir -p /tmp/workspace && mv dist node_modules /tmp/workspace'
      - persist_to_workspace:
          root: /tmp/workspace
          paths: [ dist, node_modules ]

  deploy:
    docker:
      - image: escaletech/gke-cd
    environment:
      ENV: production
      GKE_PROJECT: the-project-name
      GKE_ZONE: us-east1-b
      GKE_CLUSTER: your-cluster-name
    steps:
      - checkout
      - setup_remote_docker
      - run: gcloud-setup.sh # Setup gcloud authentication and configuration
      - attach_workspace:
          at: /tmp/workspace
      - run:
          name: Restore workspace
          command: 'set -exu && mv /tmp/workspace/dist /tmp/workspace/node_modules .'
      - run: 'docker build -t us.gcr.io/escale-os/sitemon:${CIRCLE_SHA1} ./' # build image
      - run: 'gcloud docker -- push us.gcr.io/escale-os/sitemon:${CIRCLE_SHA1}' # push image
      - run:
          name: Apply Kubernetes config
          command: 'cat kube.yml | envsubst | kube apply -f' - # apply Kubernetes config, replacing env vars
```
