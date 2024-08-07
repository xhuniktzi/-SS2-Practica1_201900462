docker pull mcr.microsoft.com/mssql/server:2019-latest
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=BaseDatos2+" -p 1433:1433 -v .\input:/data --name sqlserver -d mcr.microsoft.com/mssql/server:2019-latest
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sqlserver
