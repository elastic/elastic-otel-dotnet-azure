ARG OTEL_VERSION=1.0.0-alpha.5
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS otel
ARG OTEL_VERSION
WORKDIR /app
RUN apt-get update && apt-get install -y unzip
# install OpenTelemetry .NET Automatic Instrumentation
# the following commented line does not work from TestContainers because it does not utilize buildkit which `docker build` does OOTB
#ADD --chown=$APP_UID --chmod=777 https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/otel-dotnet-auto-install.sh otel-dotnet-auto-install.sh
#ADD https://github.com/opentelemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/otel-dotnet-auto-install.sh otel-dotnet-auto-install.sh
ADD https://github.com/elastic/elastic-otel-dotnet/releases/download/${OTEL_VERSION}/elastic-dotnet-auto-install.sh elastic-dotnet-auto-install.sh
RUN chmod +x elastic-dotnet-auto-install.sh
RUN OTEL_DOTNET_AUTO_HOME="/app/otel" sh elastic-dotnet-auto-install.sh
RUN chmod +x /app/otel/instrument.sh

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY ["dotnet-api.csproj", "dotnet-api.csproj"]
RUN dotnet restore "dotnet-api.csproj"
COPY . .
RUN dotnet build "dotnet-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-api.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

COPY --from=otel /app/otel /app/otel
COPY --from=publish /app/publish /app/publish

# create a new user and change directory ownership
RUN adduser --disabled-password \
    --home /app \
    --gecos '' dotnetuser && chown -R dotnetuser /app

# impersonate into the new user
USER dotnetuser
WORKDIR /app/publish

ENV OTEL_DOTNET_AUTO_HOME=/app/otel
ENV OTEL_LOG_LEVEL=debug
ENTRYPOINT ["/app/otel/instrument.sh", "dotnet", "dotnet-api.dll"]

EXPOSE 8080 443
