FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5200
EXPOSE 5201

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY ["hello-api/hello-api.csproj", "hello-api/"]
RUN dotnet restore "hello-api/hello-api.csproj"
COPY . .

WORKDIR "/src/hello-api"
RUN dotnet build "hello-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hello-api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hello-api.dll"]