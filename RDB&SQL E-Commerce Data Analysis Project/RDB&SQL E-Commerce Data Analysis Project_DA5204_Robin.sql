--- Create a Database
CREATE DATABASE ecommerce;

--- Use the Database
USE ecommerce;

--- Create the table
CREATE TABLE e_commerce_data (
    Ord_ID INT,
    Cust_ID INT,
    Prod_ID INT,
    Ship_ID INT,
    Order_Date DATE,
    Ship_Date DATE,
    Customer_Name VARCHAR(255),
    Province VARCHAR(255),
    Region VARCHAR(255),
    Customer_Segment VARCHAR(255),
    Sales DECIMAL(10,2),
    Order_Quantity INT,
    Order_Priority VARCHAR(255),
    DaysTakenForShipping INT
);


--- Import the csv File
LOAD DATA INFILE '/path/to/your/csv/e_commerce_data.csv' 
INTO TABLE e_commerce_data 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

