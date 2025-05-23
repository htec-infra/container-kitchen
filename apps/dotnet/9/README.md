# Distroless .NET docker image

## Overview

.NET docker image is built on top of `base-debian12` distroless image. .NET binary is configured to run as nonroot user. Binary is copied from the official microsoft aspnet9.0 image.

## Usage

### Local testing

Image built using `container-ops.sh` script has `local/REPONAME/dotnet9.0` tag, yet image is available locally only if you run
build as `DRY_RUN=true make dotnet9`.

### Example

We will use hello-world .NET app for this example.
Dockerfile example:

```

# We are going to use debian based images for the builder stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-bullseye-slim AS builder

# Set working
WORKDIR /source

# Copy csproj and restore as distinct layers
COPY *.csproj ./

# Dwonload .NET dependencies
RUN dotnet restore

# Copy the source code into the workdir
COPY . .

# Publish the app, we have 2 flags here --runtime(https://docs.microsoft.com/en-us/dotnet/core/rid-catalog) and slef-contained (https://docs.microsoft.com/en-us/dotnet/core/deploying/)
RUN dotnet publish \
    --runtime linux-x64 \
    --self-contained true \
    -c Release \
    -o out

FROM public.ecr.aws/htec/dotnet:9.0

# First we need to copy the files into the directory, in that way we assign the permissions to the folder for the nonroot user
COPY --from=builder --chown=nonroot:nonroot /source/out /app/

# Change working dir
WORKDIR /app

ENTRYPOINT ["./hello-world"]


```
