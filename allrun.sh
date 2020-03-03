rm -rf ~/vjcode/deleteme001
mkdir -p ~/vjcode/deleteme001
cd ~/vjcode/deleteme001
dotnet new webapi --no-https
cd deleteme001
echo -e 'Dockerfile\nbin\nobj' >  .dockerignore
echo -e '
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY deleteme001.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c release -o /output
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /output .
ENTRYPOINT ["dotnet", "deleteme001.dll"]
' > Dockerfile
docker build -t deleteme001:1.0 .
docker run -d -p 8435:80 deleteme001:1.0
curl http://localhost:8435/weatherforecast
