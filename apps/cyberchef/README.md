# Distroless CyberChef docker image

## Overview
CyberChef docker image is built on top of `public.ecr.aws/htec/nginx:1.22.1` distroless/rootless image. The main nginx process is configured to run
as user 1001, hence the app is not accessible on port 80 but 8080 instead.

## Usage

### Local testing

> **NOTE:**
Image is built using `container-ops.sh` script has `local/REPONAME/cyberchef` tag, yet image is available locally only if you run
build as `DRY_RUN=true make cyberchef`.


```
docker run -it --rm -p 8080:8080 local/REPONAME/cyberchef:latest
```

### From AWS ECR

```
docker run -it --rm -p 8080:8080 public.ecr.aws/htec/cyberchef:latest
```

Open your browser on http://localhost:8080/
