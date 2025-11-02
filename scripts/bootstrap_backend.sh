#!/usr/bin/env bash
set -euo pipefail
REGION="${1:-us-east-1}"
BUCKET="${2:-nyk-tf-state-$RANDOM}"
LOCK="${3:-nyk-tf-lock}"
TAGS='{"Project":"nyk-demo","Owner":"Juan"}'

cat > infra/modules/s3_backend/backend.auto.tfvars <<EOF
region        = "${REGION}"
bucket_name   = "${BUCKET}"
lock_table_name = "${LOCK}"
tags = ${TAGS}
EOF

terraform -chdir=infra/modules/s3_backend init
terraform -chdir=infra/modules/s3_backend apply -auto-approve

BUCKET_OUT=$(terraform -chdir=infra/modules/s3_backend output -raw bucket)
LOCK_OUT=$(terraform -chdir=infra/modules/s3_backend output -raw lock_table)

sed -i "s/REPLACE_ME_BUCKET/${BUCKET_OUT}/"   infra/environments/dev/main.tf
sed -i "s/REPLACE_ME_REGION/${REGION}/"       infra/environments/dev/main.tf
sed -i "s/REPLACE_ME_LOCK_TABLE/${LOCK_OUT}/" infra/environments/dev/main.tf

echo "Backend created. Bucket: ${BUCKET_OUT}, Lock table: ${LOCK_OUT}"
echo "Next: cd infra/environments/dev && terraform init && terraform apply"
