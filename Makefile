
.PHONY: cyberchef
cyberchef:
	./docker-ops.sh cyberchef latest

.PHONY: nginx
nginx:
	./docker-ops.sh nginx 1.19.7