
.PHONY: cyberchef
cyberchef:
	./docker-ops.sh cyberchef

.PHONY: nginx
nginx:
	./docker-ops.sh nginx

.PHONY: terraform
	./docker-ops.sh terraform

.PHONY: clamav
clamav:
	./docker-ops.sh clamav