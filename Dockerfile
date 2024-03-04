FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "src/Pedro.Api.Backend/Pedro.Api.Backend.csproj"
RUN dotnet build "src/Pedro.Api.Backend/Pedro.Api.Backend.csproj" -c Release -o /app/build

# The dotnet build command produces intermediate build artifacts (e.g., object files) 
# that are necessary for building but not required in the final runtime image

# Separating the build stage from the publish stage allows you to discard unnecessary build
# artifacts and only include the compiled, optimized binaries in the final image.

FROM build AS publish
RUN dotnet publish "src/Pedro.Api.Backend/Pedro.Api.Backend.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pedro.Api.Backend.csproj"]