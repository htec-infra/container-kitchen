
.PHONY: cyberchef
cyberchef:
	./docker-ops.sh cyberchef

.PHONY: nginx
nginx:
	./docker-ops.sh nginx

.PHONY: terraform
terraform:
	./docker-ops.sh terraform

.PHONY: terragrunt
terragrunt:
	./docker-ops.sh terragrunt

.PHONY: terraform-utils
terraform-utils:
	./docker-ops.sh terraform-utils

.PHONY: clamav
clamav:
	./docker-ops.sh clamav


.PHONY: pdf-generator
pdf-generator:
	./docker-ops.sh pdf-generator