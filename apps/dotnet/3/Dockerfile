FROM mcr.microsoft.com/dotnet/aspnet:3.1-buster-slim as runtime

# Create runtime image
FROM gcr.io/distroless/base-debian10:nonroot

# Copy dependencies from the official microsoft image
COPY --from=runtime /usr/bin/dotnet /usr/bin/dotnet
COPY --from=runtime /usr/lib /usr/lib
COPY --from=runtime /lib /lib

# Set least privileged user
USER nonroot

