oc new-project ntnx-system

cat <<EOF | oc create -f -
apiVersion: v1
kind: Secret
metadata:
  name: ntnx-secret
  namespace: ntnx-system
stringData:
  key: $1:9440:admin:$2
EOF

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ntnx-system-opgroup
  namespace: ntnx-system
spec:
  targetNamespaces:
  - ntnx-system
EOF

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: nutanixcsioperator
  namespace: ntnx-system
spec:
  namespace: ntnx-system
  tolerations:
  - key: "node-role.kubernetes.io/infra"
    operator: "Exists"
    value: ""
    effect: "NoSchedule"
  channel: stable
  name: nutanixcsioperator
  installPlanApproval: Automatic
  source: certified-operators
  sourceNamespace: openshift-marketplace
EOF

ATTEMPTS=0
ROLLOUT_STATUS_CMD="oc wait --for=condition=available --timeout=120s -n ntnx-system deployments nutanix-csi-operator-controller-manager"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 12 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((attempts + 1))
  sleep 10
done

cat <<EOF | oc create -f -
apiVersion: crd.nutanix.com/v1alpha1
kind: NutanixCsiStorage
metadata:
  name: nutanixcsistorage
  namespace: ntnx-system
spec:
  namespace: ntnx-system
  tolerations:
  - key: "node-role.kubernetes.io/infra"
    operator: "Exists"
    value: ""
    effect: "NoSchedule"
  openshift:
    masterIscsiConfig: true
    workerIscsiConfig: true
EOF

cat <<EOF | oc create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nutanix-volume
provisioner: csi.nutanix.com
parameters:
  csi.storage.k8s.io/provisioner-secret-name: ntnx-secret
  csi.storage.k8s.io/provisioner-secret-namespace: ntnx-system
  csi.storage.k8s.io/node-publish-secret-name: ntnx-secret
  csi.storage.k8s.io/node-publish-secret-namespace: ntnx-system
  csi.storage.k8s.io/controller-expand-secret-name: ntnx-secret
  csi.storage.k8s.io/controller-expand-secret-namespace: ntnx-system
  csi.storage.k8s.io/fstype: ext4
  storageContainer: $3
  storageType: NutanixVolumes
  #whitelistIPMode: ENABLED
  #chapAuth: ENABLED
allowVolumeExpansion: true
reclaimPolicy: Delete
EOF

oc patch storageclass nutanix-volume -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'


