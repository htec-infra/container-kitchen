FROM alpine:latest as build
ARG VERSION
ENV TERRAFORM_VERSION=${VERSION:-0.14.1}

RUN apk add --update bash curl openssl grep
#
# Terragrunt installer
#
RUN TERRAGRUNT_VERSION=$(curl -i -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && curl -LJ -o /bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
RUN chmod +x /bin/terragrunt

# Cleanup ZIP files
RUN rm -f *.zip

FROM htec/terraform:${TERRAFORM_VERSION}
COPY --from=build --chown=nonroot:nonroot /bin/terragrunt /bin/terragrunt
USER nonroot
WORKDIR /home/nonroot
ENTRYPOINT ["terragrunt"]