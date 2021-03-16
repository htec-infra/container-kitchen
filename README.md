# Rootless/Distroless Docker images

## Overview
Docker images available on Docker Hub or similar Docker registries are developed mainly for testing purposes. 
Main process is executed as a root user, and a bunch of unused libraries remain installed on the docker image although 
it's not utilized in the main process.

The idea with this repository is to build and distribute rootless docker images built on top of distroless docker images 
(if that's possible) that can be used for building more sophisticated images in the future.
Dockerfiles are defined only with the most important libraries and configuration files, hence all good practices are 
fulfilled and attacking surface is minimal.

## Applications

### Base images for Web apps
- [NGINX](https://github.com/nginxinc) unprivileged

### Utility Apps

- [ClamAV](https://www.clamav.net/) - OpenSource AntiVirus engine
- [CyberChef](https://github.com/gchq/CyberChef) - Swiss-Army Knife tool
- [Terraform](https://www.terraform.io/) - Infrastructure As Code tool
- [Terragrunt](https://terragrunt.gruntwork.io/) (based on Terraform image) - Wrapper for Terraform configuration
- Terraform Utils - Bundle of terraform linter & security check tools  
- [PDF Generator](https://github.com/alvarcarto/url-to-pdf-api) - Web page PDF rendering tool

## Development

### Prerequisites

- [docker](https://docs.docker.com/engine/install/)
- [pre-commit](https://pre-commit.com/#install)
### Usage

> **NOTE:**
The script `infra/docker-ops.sh` is configured to clean up all images after build. Run locally using `LOCAL_TEST=true` 
in order to keep built image available after the script ended.

```shell
$ LOCAL_TEST=true make <app_name>
```
