
CREATE TABLE DimPassenger (
    PassengerID NVARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Gender NVARCHAR(10)
);

CREATE TABLE DimCountry (
    CountryID INT PRIMARY KEY IDENTITY,
    CountryName NVARCHAR(100),
    CountryCode NVARCHAR(50)
);

CREATE TABLE DimAirport (
    AirportID INT PRIMARY KEY IDENTITY,
    AirportName NVARCHAR(200),
    AirportCountryCode NVARCHAR(50),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES DimCountry(CountryID)
);


CREATE TABLE DimContinent (
    ContinentID INT PRIMARY KEY IDENTITY,
    ContinentName NVARCHAR(50)
);

CREATE TABLE DimPilot (
    PilotID INT PRIMARY KEY IDENTITY,
    PilotName NVARCHAR(100)
);

CREATE TABLE FactFlight (
    FlightID INT PRIMARY KEY IDENTITY,
    PassengerID NVARCHAR(50),
    DepartureDate DATE,
    ArrivalAirportID INT,
    PilotID INT,
    FlightStatus NVARCHAR(50),
    Age INT,
    NationalityID INT,
    AirportCountryCode NVARCHAR(10),
    CountryName NVARCHAR(100),
    ContinentID INT,
    FOREIGN KEY (PassengerID) REFERENCES DimPassenger(PassengerID),
    FOREIGN KEY (ArrivalAirportID) REFERENCES DimAirport(AirportID),
    FOREIGN KEY (PilotID) REFERENCES DimPilot(PilotID),
    FOREIGN KEY (NationalityID) REFERENCES DimCountry(CountryID),
    FOREIGN KEY (ContinentID) REFERENCES DimContinent(ContinentID)
);