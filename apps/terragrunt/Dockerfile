ARG VERSION=0.14.1

FROM alpine:3.13.5 as build
# hadolint ignore=DL3018
RUN apk add --no-cache bash curl openssl grep

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
#
# Terragrunt installer
#
RUN TERRAGRUNT_VERSION=$(curl -i -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && curl -LJ -o /bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
RUN chmod +x /bin/terragrunt

# Cleanup ZIP files
RUN rm -f ./*.zip

FROM public.ecr.aws/htec/terraform:$VERSION
COPY --from=build --chown=nonroot:nonroot /bin/terragrunt /bin/terragrunt
USER nonroot
WORKDIR /home/nonroot
ENTRYPOINT ["terragrunt"]
