
.PHONY: cyberchef
cyberchef:
	docker build -t htec/cyberchef:latest -f cyberchef/Dockerfile .
	