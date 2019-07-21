FROM microsoft/dotnet:2.1.3-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /
COPY dotnetcore-api.sln ./
COPY src/dotnetcore-api.csproj src/
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
WORKDIR /src
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dotnetcore-api.dll"]