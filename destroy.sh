set -e

export TF_VAR_nutanix_subnet="Primary"
export TF_VAR_nutanix_cluster="PHX-SPOC014-4"
export TF_VAR_PC_USER=admin
export TF_VAR_PC_PASS="nx2Tech012!"
export TF_VAR_PC_ENDPOINT="10.38.14.201"

export PKR_VAR_PC_USER=admin
export PKR_VAR_PC_PASS="nx2Tech012!"
export PKR_VAR_PC_ENDPOINT="10.38.14.201"

export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' ./packer/manifest.json)

export TF_VAR_registry_ip="10.38.14.210"
export TF_VAR_registry_name="registry-vm"
export TF_VAR_registry_fqdn="ds-registry.dachlab.net"

export TF_VAR_installer_name="installer-vm"


cd installer
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
