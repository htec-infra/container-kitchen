# Distroless CyberChef docker image

## Overview
Nginx docker image is built on top of `htec/nginx:1.18.0` distroless/rootless image. The main nginx process is configured to run
as user 1001, hence the app is not accessible on port 80 but 8080 instead.

## Usage

### Local testing

> **NOTE:**
Image is built using `docker-ops.sh` script has `local/cyberchef` tag, yet image is available locally only if you run
build as `LOCAL_TEST=true make cyberchef`.


```
docker run -it --rm -p 8080:8080 local/cyberchef:latest
```

### From DockerHub

```
docker run -it --rm -p 8080:8080 htec/cyberchef
```

Open your browser on http://localhost:8080/
