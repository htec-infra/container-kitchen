FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim as runtime

# Create runtime image
FROM gcr.io/distroless/base-debian11:nonroot

# Copy dependencies from the official microsoft image
COPY --from=runtime /usr/bin/dotnet /usr/bin/dotnet
COPY --from=runtime /usr/lib /usr/lib
COPY --from=runtime /lib /lib

# Set least privileged user
USER nonroot