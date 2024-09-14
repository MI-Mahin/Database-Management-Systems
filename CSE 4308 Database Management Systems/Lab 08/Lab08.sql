CREATE TABLE Division (
    DivisionID INT PRIMARY KEY,
    DivisionName VARCHAR(255)
);

CREATE TABLE District (
    DistrictID INT PRIMARY KEY,
    DistrictName VARCHAR(255),
    DivisionID INT,
    FOREIGN KEY (DivisionID) REFERENCES Division(DivisionID)
);

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(255),
    DistrictID INT,
    FOREIGN KEY (DistrictID) REFERENCES District(DistrictID)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255),
    DOB DATE,
    ContactNo VARCHAR(20),
    BranchID INT,
    DepartmentID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    ContactNo VARCHAR(20),
    Address VARCHAR(255)
);

CREATE TABLE Item (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(255),
    Description TEXT,
    UnitPrice DECIMAL(10, 2)
);

CREATE TABLE Rental (
    RentalID INT PRIMARY KEY,
    RentalStartDate DATE,
    RentalEndDate DATE,
    EmployeeID INT,
    ItemID INT,
    CustomerID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
