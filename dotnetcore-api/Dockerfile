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

# Build up to this stage, run and extract the test results
# https://stackoverflow.com/questions/59330690/extract-file-from-multistage-docker-build
# FROM build AS test
# RUN dotnet test ./test/YourProjectFileWithUnitTests.csproj --logger trx /p:CollectCoverage=true  /p:CoverletOutputFormat=Cobertura /p:CoverletOutput=./CodeCoverage/
# RUN dotnet test ./test/YourProjectFileWithServiceTests.csproj --logger trx 

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dotnetcore-api.dll"]