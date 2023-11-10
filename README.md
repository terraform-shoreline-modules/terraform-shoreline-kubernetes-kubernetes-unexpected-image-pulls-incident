
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - Unexpected Image Pulls Incident

The Unexpected Image Pulls Incident refers to an alert triggered by unexpected pulls of container images, which can indicate a compromise in the supply chain. This type of incident can occur when a container image is downloaded from an untrusted or malicious source, or when a legitimate image has been tampered with and modified to include malicious code. Such incidents can pose a serious security risk, as they can allow attackers to gain unauthorized access to systems and steal sensitive data or compromise system integrity. Prompt detection and response to this type of incident is critical to prevent further compromise and protect the security of the system.

### Parameters

```shell
export NAMESPACE="PLACEHOLDER"
export POD_NAME="PLACEHOLDER"
export DEPLOYMENT="PLACEHOLDER"
```

## Debug

### List all pods in the cluster

```shell
kubectl get pods --all-namespaces
```

### Check the logs of a specific pod

```shell
kubectl logs ${POD_NAME} -n ${NAMESPACE}
```

### Check which image a pod is using

```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE} | grep -i image
```

### Check if there are any image pull errors in the events for a pod

```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE} | grep -i error
```

### Check if there are any image pull errors in the events for the entire namespace

```shell
kubectl describe namespace ${NAMESPACE} | grep -i error
```

### Check if there are any image pull errors in the events for the entire cluster

```shell
kubectl get events --sort-by='.metadata.creationTimestamp' | grep -i error
```

## Repair

### Remove the compromised container images .

```shell
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
```