# Distroless CyberChef docker image

## Overview
Nginx docker image is built on top of `base-debian10` distroless image. The main nginx process is configured to run
as user 1001, hence nginx is not accessible on port 80 but 8080 instead.

## Usage

### Local testing

Image built using `docker-ops.sh` script has `local/nginx` tag, yet image is available locally only if you run
build as `LOCAL_TEST=true make nginx`.
```
docker run -it --rm -p 8080:8080 local/nginx:1.18.0
```

### From DockerHub

```
docker run -it --rm -p 8080:8080 htec/nginx:1.18.0
```

Open your browser on http://localhost:8080/

### Example

Take a look in `../cyberchef` directory to see distroless nginx utilization in practice.

### Credits
https://github.com/kyos0109/nginx-distroless
