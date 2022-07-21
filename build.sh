set -e

cd packer
packer build .
export TF_VAR_packer_source_image=$(jq -r '.builds[-1].artifact_id' manifest.json)

cd ../registry
terraform init
terraform apply

cd ../installer
terraform init
terraform apply
