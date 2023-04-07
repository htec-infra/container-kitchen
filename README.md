# Rootless/Distroless Docker images

## Overview
Container images available on Docker Hub or similar Container registries are developed mainly for testing purposes. 
Main process is executed as a root user, and a bunch of unused libraries remain installed on the container image although 
it's not utilized in the main process.

The idea with this repository is to build and distribute rootless container images built on top of base distroless images 
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

- [.NET-3.1](https://dotnet.microsoft.com/download/dotnet/3.1) - NET Core 3.1
- [.NET-5.0](https://dotnet.microsoft.com/download/dotnet/5.0) - NET Core 5.0
- [.NET-6.0](https://dotnet.microsoft.com/download/dotnet/6.0) - NET Core 6.0
- [.NET-7.0](https://dotnet.microsoft.com/download/dotnet/7.0) - NET Core 7.0

### Prerequisites

- [docker](https://docs.docker.com/engine/install/)
- [pre-commit](https://pre-commit.com/#install)

### Usage

> **NOTE:**
The script `infra/container-ops.sh` is configured to clean up all images after build. Run locally using `DRY_RUN=true` 
in order to keep built image available after the script ended.

```shell
$ DRY_RUN=true make <app_name> <flavor(if applicable)>
```
