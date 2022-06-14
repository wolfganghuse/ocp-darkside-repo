# Post Installation Tasks
## Create Infrastructure Nodes
Export existing worker machineset
```
oc get machineset -A
oc get machineset -n openshift-machine-api xxx-worker -o yaml > infra-nodes.yaml
```

Replace all xxx-worker entries in the new created yaml by xxx-infra

Replace worker label with infra

````
        machine.openshift.io/cluster-api-machine-role: worker (=>infra)
        machine.openshift.io/cluster-api-machine-type: worker (=>infra)
```

Add the following spec:
```
spec:
  template:
    spec:
      metadata:
        labels:
          node-role.kubernetes.io/infra: ""
      taints:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
```

Apply the new machineset

```
oc apply -f infra-nodes.yaml
```


## Deploy CSI Driver
This script will add the CSI Operator, deploy the driver itself and create a new (default) storageclass ntnx-volume

Please run with the following parameters:

```
./csi.sh PrismCentral-IP Admin-Password StorageContainer
```

## Create Image Registry
This will create a PVC for the image registry and patch the deployment to use it.
```
./image_registry.sh
```

## Move to Infrastructure Nodes
This script moves all OCP components from worker nodes toward infrastructure nodes. This includes these steps:
- Patch Ingress Controller
- Patch Image Service
- create a cluster-monitoring-config which moves
- - Alertmanager
- - Prometheus
- - Thanos, etc
