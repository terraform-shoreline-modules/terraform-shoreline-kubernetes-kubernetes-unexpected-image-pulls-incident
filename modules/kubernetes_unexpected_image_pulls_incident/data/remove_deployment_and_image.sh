bash
#!/bin/bash

# Define the namespace and deployment name
NAMESPACE=${NAMESPACE}
DEPLOYMENT=${DEPLOYMENT}

# Get the current image in use
CURRENT_IMAGE=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o=jsonpath='{.spec.template.spec.containers[0].image}')

# Remove the current deployment
kubectl delete deployment $DEPLOYMENT -n $NAMESPACE

# Remove the current image from the cluster
kubectl image prune -a --force --filter "until=24h" --filter "reference=$CURRENT_IMAGE"