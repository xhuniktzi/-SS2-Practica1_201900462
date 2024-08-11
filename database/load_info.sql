-- EXTRACT
CREATE TABLE #TemporaryFlights(
	[Passenger_ID] [nvarchar](50) NOT NULL,
	[First_Name] [nvarchar](50) NOT NULL,
	[Last_Name] [nvarchar](50) NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[Age] [tinyint] NOT NULL,
	[Nationality] [nvarchar](50) NOT NULL,
	[Airport_Name] [nvarchar](100) NOT NULL,
	[Airport_Country_Code] [nvarchar](50) NOT NULL,
	[Country_Name] [nvarchar](50) NOT NULL,
	[Airport_Continent] [nvarchar](50) NOT NULL,
	[Continents] [nvarchar](50) NOT NULL,
	[Departure_Date] [nvarchar](50) NOT NULL,
	[Arrival_Airport] [nvarchar](50) NOT NULL,
	[Pilot_Name] [nvarchar](50) NOT NULL,
	[Flight_Status] [nvarchar](50) NOT NULL
) ON [PRIMARY]

-- TRANSFORM
BULK INSERT #TemporaryFlights
FROM '/data/passengers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);

DELETE FROM #TemporaryFlights
WHERE Passenger_ID IN (
    SELECT Passenger_ID
    FROM (
        SELECT Passenger_ID, ROW_NUMBER() OVER (PARTITION BY Passenger_ID ORDER BY (SELECT NULL)) AS rn
        FROM #TemporaryFlights
    ) AS Duplicates
    WHERE rn > 1
);

DELETE FROM #TemporaryFlights
WHERE Arrival_Airport = '0';

DELETE FROM #TemporaryFlights
WHERE Continents not in ('North America','Asia','Africa','Oceania','South America','Europe','India');

DELETE FROM #TemporaryFlights
WHERE Airport_Name LIKE '%"%';

DELETE FROM #TemporaryFlights
WHERE Country_Name LIKE '%"%';

DELETE FROM #TemporaryFlights
WHERE PATINDEX('%[^ -~áéíóúÁÉÍÓÚ]%', Country_Name COLLATE Latin1_General_BIN) > 0; 

-- LOAD
INSERT INTO DimPassenger (PassengerID, FirstName, LastName, Gender)
SELECT DISTINCT Passenger_ID, First_Name, Last_Name, Gender
FROM #TemporaryFlights;

INSERT INTO DimCountry (CountryName, CountryCode)
SELECT DISTINCT Country_Name AS CountryName, Airport_Country_Code
FROM #TemporaryFlights;

INSERT INTO DimAirport (AirportName, AirportCountryCode, CountryID)
SELECT DISTINCT Airport_Name AS AirportName, Airport_Country_Code, dc.CountryID
FROM #TemporaryFlights tf
JOIN DimCountry dc ON tf.Country_Name = dc.CountryName;

INSERT INTO DimContinent (ContinentName)
SELECT DISTINCT Continents
FROM #TemporaryFlights;

INSERT INTO DimPilot (PilotName)
SELECT DISTINCT Pilot_Name
FROM #TemporaryFlights;

INSERT INTO FactFlight (PassengerID, DepartureDate, ArrivalAirportID, PilotID, FlightStatus, Age, NationalityID, AirportCountryCode, CountryName, ContinentID)
SELECT 
    tf.Passenger_ID,
    TRY_CONVERT(DATE, tf.Departure_Date, 101) AS DepartureDate, -- Conversión segura
    da.AirportID,
    dp.PilotID,
    tf.Flight_Status,
    tf.Age,
    dc.CountryID,
    tf.Airport_Country_Code,
    tf.Country_Name,
    dct.ContinentID
FROM #TemporaryFlights tf
JOIN DimAirport da ON tf.Airport_Name = da.AirportName
JOIN DimPilot dp ON tf.Pilot_Name = dp.PilotName
JOIN DimCountry dc ON tf.Country_Name = dc.CountryName
JOIN DimContinent dct ON tf.Continents = dct.ContinentName;
