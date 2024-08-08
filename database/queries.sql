
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
