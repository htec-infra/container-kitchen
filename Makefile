
.PHONY: cyberchef
cyberchef:
	./infra/container-ops.sh cyberchef

.PHONY: nginx
nginx:
	./infra/container-ops.sh nginx

.PHONY: terraform
terraform:
	./infra/container-ops.sh terraform

.PHONY: terragrunt
terragrunt:
	./infra/container-ops.sh terragrunt

.PHONY: terraform-utils
terraform-utils:
	./infra/container-ops.sh terraform-utils

.PHONY: clamav
clamav:
	./infra/container-ops.sh clamav

.PHONY: pdf-generator
pdf-generator:
	./infra/container-ops.sh pdf-generator

.PHONY: dotnet3
dotnet3:
	./infra/container-ops.sh dotnet 3

.PHONY: dotnet5
dotnet5:
	./infra/container-ops.sh dotnet 5

.PHONY: dotnet6
dotnet6:
	./infra/container-ops.sh dotnet 6

.PHONY: dotnet7
dotnet7:
	./infra/container-ops.sh dotnet 7

.PHONY: dotnet8
dotnet7:
	./infra/container-ops.sh dotnet 8