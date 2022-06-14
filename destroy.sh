set -e

export TF_VAR_nutanix_subnet="Primary"
export TF_VAR_nutanix_cluster="PHX-POC291"
export TF_VAR_PC_USER=admin
export TF_VAR_PC_PASS="nx2Tech012!"
export TF_VAR_PC_ENDPOINT="10.38.9.201"

export TF_VAR_vm_ip="10.38.9.210"

export PKR_VAR_PC_USER=admin
export PKR_VAR_PC_PASS="nx2Tech012!"
export PKR_VAR_PC_ENDPOINT="10.38.9.201"

export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' ../packer/manifest.json)

cd jumphost
terraform destroy -auto-approve
cd ..

cd registry 
terraform destroy -auto-approve
cd ..

cd prepare
terraform destroy -auto-approve
cd ..
cd packer
rm -rf manifest.json
