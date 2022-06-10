set -e

export TF_VAR_nutanix_subnet="Primary"
export TF_VAR_nutanix_cluster="PHX-POC291"
export TF_VAR_PC_USER=admin
export TF_VAR_PC_PASS="nx2Tech012!"
export TF_VAR_PC_ENDPOINT="10.38.63.39"

export PKR_VAR_PC_USER=admin
export PKR_VAR_PC_PASS="nx2Tech012!"
export PKR_VAR_PC_ENDPOINT="10.38.63.39"

cd prepare
terraform init
terraform apply -auto-approve
export PKR_VAR_mirror_image=$(terraform output -raw mirror_uuid)
export PKR_VAR_centos_image=$(terraform output -raw centos_uuid)
export PKR_VAR_nutanix_cluster=$(terraform output -raw cluster_uuid)
export PKR_VAR_nutanix_subnet=$(terraform output -raw subnet_uuid)

cd ../packer
#PACKER_LOG=debug packer build .
packer build .

export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' manifest.json)
cd ../terraform
terraform init
terraform apply -auto-approve