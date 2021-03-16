FROM alpine:latest as build
ARG VERSION
ENV TERRAFORM_VERSION=${VERSION:-0.14.1}

RUN apk add --update bash curl openssl grep
#
# Terraform
#
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin

# Cleanup ZIP files
RUN rm -f *.zip

FROM gcr.io/distroless/base-debian10
COPY --from=build --chown=nonroot:nonroot /bin/terraform /bin/terraform
USER nonroot
WORKDIR /home/nonroot
ENTRYPOINT ["terraform"]