set -e

export TF_VAR_nutanix_subnet="Primary"
export TF_VAR_nutanix_cluster="DM3-POC002"
export TF_VAR_PC_USER=admin
export TF_VAR_PC_PASS="nx2Tech012!"
export TF_VAR_PC_ENDPOINT="10.55.2.39"

export PKR_VAR_PC_USER=admin
export PKR_VAR_PC_PASS="nx2Tech012!"
export PKR_VAR_PC_ENDPOINT="10.55.2.39"

export TF_VAR_registry_ip="10.55.2.13"
export TF_VAR_registry_name="registry-vm"
export TF_VAR_registry_fqdn="ds-registry.dachlab.net"

export TF_VAR_installer_name="installer-vm"

export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' ./packer/manifest.json)



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
