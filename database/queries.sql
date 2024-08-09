
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


SELECT 
    Gender,
    COUNT(*) AS PassengerCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM DimPassenger
GROUP BY Gender;

WITH MonthlyDepartures AS (
    SELECT 
        c.CountryName,
        FORMAT(f.DepartureDate, 'MM-yyyy') AS MonthYear,
        COUNT(*) AS DepartureCount
    FROM FactFlight f
    JOIN DimCountry c ON f.NationalityID = c.CountryID
    WHERE YEAR(f.DepartureDate) = 2022
    GROUP BY c.CountryName, FORMAT(f.DepartureDate, 'MM-yyyy')
),
MaxDepartures AS (
    SELECT 
        c.CountryName,
        FORMAT(f.DepartureDate, 'MM-yyyy') AS MonthYear,
        COUNT(*) AS DepartureCount
    FROM FactFlight f
    JOIN DimCountry c ON f.NationalityID = c.CountryID
    WHERE YEAR(f.DepartureDate) = 2022
    GROUP BY c.CountryName, FORMAT(f.DepartureDate, 'MM-yyyy')
)
SELECT 
    CountryName,
    ISNULL([01-2022], 0) AS '01-2022',
    ISNULL([02-2022], 0) AS '02-2022',
    ISNULL([03-2022], 0) AS '03-2022',
    ISNULL([04-2022], 0) AS '04-2022',
    ISNULL([05-2022], 0) AS '05-2022',
    ISNULL([06-2022], 0) AS '06-2022',
    ISNULL([07-2022], 0) AS '07-2022',
    ISNULL([08-2022], 0) AS '08-2022',
    ISNULL([09-2022], 0) AS '09-2022',
    ISNULL([10-2022], 0) AS '10-2022',
    ISNULL([11-2022], 0) AS '11-2022',
    ISNULL([12-2022], 0) AS '12-2022'
FROM 
    MaxDepartures
PIVOT 
(
    SUM(DepartureCount)
    FOR MonthYear IN (
        [01-2022], [02-2022], [03-2022], 
        [04-2022], [05-2022], [06-2022], 
        [07-2022], [08-2022], [09-2022], 
        [10-2022], [11-2022], [12-2022]
    )
) AS PivotTable
ORDER BY 
    CountryName ASC;

SELECT 
    c.CountryName,
    COUNT(*) AS FlightCount
FROM FactFlight f
JOIN DimCountry c ON f.NationalityID = c.CountryID
GROUP BY c.CountryName
ORDER BY FlightCount DESC;


SELECT TOP 5
    a.AirportName,
    COUNT(*) AS PassengerCount
FROM FactFlight f
JOIN DimAirport a ON f.ArrivalAirportID = a.AirportID
GROUP BY a.AirportName
ORDER BY PassengerCount DESC;


SELECT TOP 5
    c.CountryName,
    COUNT(*) AS VisitCount
FROM FactFlight f
JOIN DimCountry c ON f.NationalityID = c.CountryID
GROUP BY c.CountryName
ORDER BY VisitCount DESC;

SELECT 
    COUNT(*) AS FlightCount,
        f.FlightStatus
FROM FactFlight f
GROUP BY FlightStatus;

SELECT TOP 5
    ct.ContinentName,
    COUNT(*) AS VisitCount
FROM FactFlight f
JOIN DimContinent ct ON f.ContinentID = ct.ContinentID
GROUP BY ct.ContinentName
ORDER BY VisitCount DESC;

SELECT TOP 5
    Age,
    Gender,
    COUNT(*) AS TravelCount
FROM FactFlight f
JOIN DimPassenger p ON f.PassengerID = p.PassengerID
GROUP BY Age, Gender
ORDER BY TravelCount DESC;

SELECT 
    FORMAT(DepartureDate, 'MM-yyyy') AS MonthYear,
    COUNT(*) AS FlightCount
FROM FactFlight
GROUP BY FORMAT(DepartureDate, 'MM-yyyy')
ORDER BY FORMAT(DepartureDate, 'MM-yyyy');
