PRINT('Consulta 1');
SELECT 'DimPassenger' AS TableName, COUNT(*) AS RecordCount FROM DimPassenger
UNION ALL
SELECT 'DimCountry', COUNT(*) FROM DimCountry
UNION ALL
SELECT 'DimAirport', COUNT(*) FROM DimAirport
UNION ALL
SELECT 'DimContinent', COUNT(*) FROM DimContinent
UNION ALL
SELECT 'DimPilot', COUNT(*) FROM DimPilot
UNION ALL
SELECT 'FactFlight', COUNT(*) FROM FactFlight;

PRINT('Consulta 2');
SELECT 
    Gender,
    COUNT(*) AS PassengerCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM DimPassenger
GROUP BY Gender;

PRINT('Consulta 3');
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
SELECT CountryName, MonthYear, DepartureCount
FROM MaxDepartures
WHERE Rank = 1
ORDER BY CountryName;

PRINT('Consulta 4');
-- SELECT 
--     c.CountryName,
--     COUNT(*) AS FlightCount
-- FROM FactFlight f
-- JOIN DimCountry c ON f.NationalityID = c.CountryID
-- GROUP BY c.CountryName
-- ORDER BY FlightCount DESC;

PRINT('Consulta 5');
SELECT TOP 5
    a.AirportName,
    COUNT(*) AS PassengerCount
FROM FactFlight f
JOIN DimAirport a ON f.ArrivalAirportID = a.AirportID
GROUP BY a.AirportName
ORDER BY PassengerCount DESC;

PRINT('Consulta 6');
-- SELECT 
--     FlightStatus,
--     COUNT(*) AS FlightCount
-- FROM FactFlight
-- GROUP BY FlightStatus;

PRINT('Consulta 7');
SELECT TOP 5
    c.CountryName,
    COUNT(*) AS VisitCount
FROM FactFlight f
JOIN DimCountry c ON f.NationalityID = c.CountryID
GROUP BY c.CountryName
ORDER BY VisitCount DESC;

PRINT('Consulta 8');
SELECT TOP 5
    ct.ContinentName,
    COUNT(*) AS VisitCount
FROM FactFlight f
JOIN DimContinent ct ON f.ContinentID = ct.ContinentID
GROUP BY ct.ContinentName
ORDER BY VisitCount DESC;

PRINT('Consulta 9');
SELECT TOP 5
    Age,
    Gender,
    COUNT(*) AS TravelCount
FROM FactFlight f
JOIN DimPassenger p ON f.PassengerID = p.PassengerID
GROUP BY Age, Gender
ORDER BY TravelCount DESC;

PRINT('Consulta 10');
SELECT 
    FORMAT(DepartureDate, 'MM-yyyy') AS MonthYear,
    COUNT(*) AS FlightCount
FROM FactFlight
GROUP BY FORMAT(DepartureDate, 'MM-yyyy')
ORDER BY FORMAT(DepartureDate, 'MM-yyyy');
