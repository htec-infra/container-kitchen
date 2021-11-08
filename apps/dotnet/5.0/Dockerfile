# Create runtime image
FROM gcr.io/distroless/base-debian10

# Copy dependencies from the official microsoft image
COPY --from=mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim /usr/bin/dotnet /usr/bin/dotnet
COPY --from=mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim /usr/lib /usr/lib
COPY --from=mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim /lib /lib

# Set least privileged user
USER nonroot