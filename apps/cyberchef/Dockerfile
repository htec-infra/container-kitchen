FROM node:11-alpine as build
# hadolint ignore=DL3018
RUN apk --no-cache add curl jq unzip

WORKDIR /app/build

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
# hadolint ignore=SC2035
RUN REL=$(curl -ksL "https://api.github.com/repos/gchq/CyberChef/releases/latest" | jq -r '.tag_name') && \
    curl -s -L -O "https://github.com/gchq/CyberChef/releases/download/${REL}/CyberChef_${REL}.zip" && \
    unzip -u "CyberChef_${REL}.zip" && \
    mv "CyberChef_*.html" index.html && \
    rm *.zip

FROM public.ecr.aws/htec/nginx:1.20.1
LABEL maintainer='DevSecOps HTEC <devsecops@htecgroup.com>'
COPY --from=build /app/build /usr/share/nginx/html
