docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=BaseDatos2+" -p 1434:1433 -v .\input:/data --name sqlserver2 -d mcr.microsoft.com/mssql/server:2022-latest
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sqlserver
