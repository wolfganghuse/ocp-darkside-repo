set -e

export TF_VAR_nutanix_subnet="Primary"
export TF_VAR_nutanix_cluster="PHX-SPOC014-4"
export TF_VAR_PC_USER=admin
export TF_VAR_PC_PASS="nx2Tech012!"
export TF_VAR_PC_ENDPOINT="10.38.14.201"

export PKR_VAR_PC_USER=admin
export PKR_VAR_PC_PASS="nx2Tech012!"
export PKR_VAR_PC_ENDPOINT="10.38.14.201"

export TF_VAR_registry_ip="10.38.14.210"
export TF_VAR_registry_name="registry-vm"
export TF_VAR_registry_fqdn="ds-registry.dachlab.net"

export TF_VAR_installer_name="installer-vm"


cd prepare
terraform init
terraform apply
export PKR_VAR_mirror_image=$(terraform output -raw mirror_uuid)
export PKR_VAR_centos_image=$(terraform output -raw centos_uuid)
export PKR_VAR_nutanix_cluster=$(terraform output -raw cluster_uuid)
export PKR_VAR_nutanix_subnet=$(terraform output -raw subnet_uuid)

cd ../packer
packer build .
export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' manifest.json)

cd ../registry
terraform init
terraform apply

cd ../installer
terraform init
terraform apply
