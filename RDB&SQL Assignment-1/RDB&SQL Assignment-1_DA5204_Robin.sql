---- creating new database
CREATE DATABASE Manufacturer

-- using Database
USE Manufacturer

-- Create SCHEMA
--- Product
CREATE SCHEMA Product

-- Create the tables

CREATE TABLE Product (
    prod_id INT PRIMARY KEY,
    prod_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE Component (
    comp_id INT PRIMARY KEY,
    comp_name VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL,
    quantity_comp INT NOT NULL
);

CREATE TABLE Supplier (
    supp_id INT PRIMARY KEY,
    supp_name VARCHAR(50) NOT NULL,
    supp_location VARCHAR(50) NOT NULL,
    supp_country VARCHAR(50) NOT NULL,
    is_active BIT NOT NULL
);

CREATE TABLE Comp_Supp (
    supp_ID INT PRIMARY KEY,
    comp_id INT,
    order_date DATE,
    quantity INT
);

CREATE TABLE Prod_Comp (
    prod_id INT PRIMARY KEY,
    comp_id INT,
    quantitiy_comp INT,
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id)
);


-- Define Table constraints
--- Constraint Prod_Comp 1
ALTER TABLE Prod_Comp
ADD CONSTRAINT fk_Prod_Comp_Product
FOREIGN KEY (prod_id)
REFERENCES Product (prod_id)
ON DELETE CASCADE;

--- Contraint Prod_Comp 2
ALTER TABLE Prod_Comp
ADD CONSTRAINT fk_Prod_Comp_Component
FOREIGN KEY (comp_id)
REFERENCES Component (comp_id)
ON DELETE CASCADE;

--- Contraint Comp_Supp 1
ALTER TABLE Comp_Supp
ADD CONSTRAINT fk_Comp_Supp_Component
FOREIGN KEY (comp_id)
REFERENCES Component (comp_id)
ON DELETE CASCADE;

--- Contraint Comp_Supp 2
ALTER TABLE Comp_Supp
ADD CONSTRAINT fk_Comp_Supp_Supplier
FOREIGN KEY (supp_id)
REFERENCES Supplier (supp_id)
ON DELETE CASCADE;


