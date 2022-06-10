cd packer
packer build .
export TF_VAR_source_image=$(jq -r '.builds[-1].artifact_id' manifest.json)
cd ../terraform
terraform init
terraform apply -auto-approve
