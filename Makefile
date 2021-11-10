
.PHONY: cyberchef
cyberchef:
	./infra/docker-ops.sh cyberchef

.PHONY: nginx
nginx:
	./infra/docker-ops.sh nginx

.PHONY: terraform
terraform:
	./infra/docker-ops.sh terraform

.PHONY: terragrunt
terragrunt:
	./infra/docker-ops.sh terragrunt

.PHONY: terraform-utils
terraform-utils:
	./infra/docker-ops.sh terraform-utils

.PHONY: clamav
clamav:
	./infra/docker-ops.sh clamav

.PHONY: pdf-generator
pdf-generator:
	./infra/docker-ops.sh pdf-generator


.PHONY: dotnet
dotnet3.1:
	./infra/docker-ops.sh dotnet/3.1

.PHONY: dotnet
dotnet5.0:
	./infra/docker-ops.sh dotnet/5.0

.PHONY: dotnet
dotnet6.0:
	./infra/docker-ops.sh dotnet/6.0