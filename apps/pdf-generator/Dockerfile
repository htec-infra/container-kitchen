FROM node:10-alpine

RUN apk update
# hadolint ignore=DL3018
RUN apk add --no-cache \
    udev \
    ttf-freefont \
    chromium \
    dumb-init \
    git

ENV BROWSER_EXECUTABLE_PATH "/usr/bin/chromium-browser"
# Skip downloading Chromium when installing puppeteer. We'll use the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD "true"

WORKDIR /app

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app
# hadolint ignore=DL3003
RUN cd /tmp && \
    git clone https://github.com/alvarcarto/url-to-pdf-api && \
    cp -r /tmp/url-to-pdf-api/* /app

RUN npm install

RUN echo "" > .env

USER pptruser

EXPOSE 9000

ENTRYPOINT [ "dumb-init", "--" ]
CMD [ "npm", "start" ]
