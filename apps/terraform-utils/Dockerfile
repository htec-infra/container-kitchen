FROM alpine:latest as build

RUN apk add --update bash curl openssl grep tar
#
# TFLint installer
#
RUN TFLINT_VERSION=$(curl -i -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && curl -LJ -O "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip"
RUN unzip tflint_linux_amd64.zip -d /bin

#
# TFSec installer
#
RUN TFSEC_VERSION=$(curl -i -s https://api.github.com/repos/tfsec/tfsec/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && curl -LJ -o /bin/tfsec "https://github.com/tfsec/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64"
RUN chmod +x /bin/tfsec

#
# Terrascan
#
RUN TERRASCAN_DOWNLOAD_URL=$(curl -i -s https://api.github.com/repos/accurics/terrascan/releases/latest | \
        grep -oP '"browser_download_url": "\K(.*)(?=")' | grep -i linux_x86_64) \
        && curl --location "${TERRASCAN_DOWNLOAD_URL}" --output terrascan.tar.gz \
        && tar -xvf terrascan.tar.gz \
        && install terrascan /bin

FROM gcr.io/distroless/base-debian10
COPY --from=build --chown=nonroot:nonroot /bin/tflint /bin/tflint
COPY --from=build --chown=nonroot:nonroot /bin/tfsec /bin/tfsec
COPY --from=build --chown=nonroot:nonroot /bin/terrascan /bin/terrascan

USER nonroot
WORKDIR /home/nonroot