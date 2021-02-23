
.PHONY: cyberchef
cyberchef:
	docker build -t htec/cyberchef:latest -f cyberchef/Dockerfile .

.PHONY: nginx
nginx:
	docker build -t htec/nginx:latest -f nginx/Dockerfile .