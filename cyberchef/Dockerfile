FROM node:11-alpine as build

RUN apk add curl jq unzip && \
    rm -rf /var/cache/apk/*

WORKDIR /app/build

RUN REL=$(curl -ksL "https://api.github.com/repos/gchq/CyberChef/releases/latest" | jq -r '.tag_name') && \
    curl -s -L -O "https://github.com/gchq/CyberChef/releases/download/${REL}/CyberChef_${REL}.zip" && \
    unzip -u CyberChef_${REL}.zip && \
    mv CyberChef_*.html index.html && \
    rm *.zip

FROM htec/nginx:1.19.7
LABEL maintainer='DevSecOps HTEC <devsecops@htecgroup.com>'
COPY --from=build /app/build /usr/share/nginx/html


