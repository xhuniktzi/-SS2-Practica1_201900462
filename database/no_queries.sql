-- consulta 3 no entendi
WITH MonthlyDepartures AS (
    SELECT 
        c.CountryName,
        FORMAT(f.DepartureDate, 'MM-yyyy') AS MonthYear,
        COUNT(*) AS DepartureCount
    FROM FactFlight f
    JOIN DimCountry c ON f.NationalityID = c.CountryID
    GROUP BY c.CountryName, FORMAT(f.DepartureDate, 'MM-yyyy')
),
MaxDepartures AS (
    SELECT 
        CountryName,
        MonthYear,
        DepartureCount,
        RANK() OVER (PARTITION BY CountryName ORDER BY DepartureCount DESC) AS Rank
    FROM MonthlyDepartures
)
SELECT 
    CountryName, 
    MonthYear, 
    DepartureCount
FROM 
    MaxDepartures
WHERE 
    Rank = 1
ORDER BY 
    CountryName ASC;

-- consulta 6 no se muestra columna izq
SELECT 
    FlightStatus,
    COUNT(*) AS FlightCount
FROM FactFlight
GROUP BY FlightStatus;