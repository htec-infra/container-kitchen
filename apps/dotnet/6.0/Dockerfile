# Create runtime image
FROM gcr.io/distroless/base-debian11

# Copy dependencies from the official microsoft image
COPY --from=mcr.microsoft.com/dotnet/aspnet:6.0.0-bullseye-slim /usr/bin/dotnet /usr/bin/dotnet
COPY --from=mcr.microsoft.com/dotnet/aspnet:6.0.0-bullseye-slim /usr/lib /usr/lib
COPY --from=mcr.microsoft.com/dotnet/aspnet:6.0.0-bullseye-slim /lib /lib

# Set least privileged user
USER nonroot