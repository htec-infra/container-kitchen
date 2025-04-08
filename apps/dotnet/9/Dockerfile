FROM mcr.microsoft.com/dotnet/aspnet:9.0-bookworm-slim as runtime

# Create runtime image
FROM gcr.io/distroless/base-debian12:nonroot

# Copy dependencies from the official microsoft image
COPY --from=runtime /usr/bin/dotnet /usr/bin/dotnet
COPY --from=runtime /usr/lib /usr/lib
COPY --from=runtime /lib /lib

# Set least privileged user
USER nonroot