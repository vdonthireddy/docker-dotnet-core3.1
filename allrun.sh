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
ENV ASPNETCORE_URLS=http://+:8435
ENTRYPOINT ["dotnet", "deleteme001.dll"]
' > Dockerfile
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f deleteme001
docker build -t deleteme001:1.0 .
docker run -d -p 8193:8435 --name deleteme001 deleteme001:1.0
echo '3...'
sleep 1s
echo '2...'
sleep 1s
echo '1...'
sleep 1s
curl http://localhost:8193/weatherforecast
