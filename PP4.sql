-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Customer Addresses Table (1:N with Customers)
CREATE TABLE CustomerAddresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    Street VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 3. Sellers Table
CREATE TABLE Sellers (
    SellerID INT PRIMARY KEY AUTO_INCREMENT,
    SellerName VARCHAR(100) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    SellerID INT NOT NULL,
    Category VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SellerID) REFERENCES Sellers(SellerID) ON DELETE CASCADE
);

-- 5. Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 6. OrderItems Table (Junction table for Order <-> Product M:N relationship)
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    UNIQUE (OrderID, ProductID)  -- ensures same product is not added twice per order
);

-- 7. Payments Table (1:1 or 1:N depending on split payments)
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- 8. Shipments Table (1:1 with Orders)
CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    ShipmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Carrier VARCHAR(50),
    TrackingNumber VARCHAR(50) UNIQUE,
    Status VARCHAR(20) DEFAULT 'Processing',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber) VALUES
('Amit', 'Sharma', 'amit.sharma@email.com', '9876543210'),
('Neha', 'Verma', 'neha.verma@email.com', '9123456780'),
('Rahul', 'Mehta', 'rahul.mehta@email.com', '9988776655'),
('Priya', 'Iyer', 'priya.iyer@email.com', '9012345678'),
('Karan', 'Singh', 'karan.singh@email.com', '9090909090');

INSERT INTO CustomerAddresses (CustomerID, Street, City, State, PostalCode, Country) VALUES
(1, '12 MG Road', 'Bangalore', 'Karnataka', '560001', 'India'),
(1, '45 Residency Rd', 'Bangalore', 'Karnataka', '560025', 'India'),
(2, '18 Park Street', 'Kolkata', 'West Bengal', '700016', 'India'),
(3, '77 Linking Road', 'Mumbai', 'Maharashtra', '400050', 'India'),
(4, '9 T Nagar', 'Chennai', 'Tamil Nadu', '600017', 'India'),
(5, '101 Sector 22', 'Chandigarh', 'Chandigarh', '160022', 'India');

INSERT INTO Sellers (SellerName, Email, PhoneNumber) VALUES
('TechWorld', 'support@techworld.com', '8001112222'),
('HomeEssentials', 'contact@homeessentials.com', '8003334444'),
('FashionHub', 'info@fashionhub.com', '8005556666'),
('BookPlanet', 'sales@bookplanet.com', '8007778888'),
('GadgetStore', 'help@gadgetstore.com', '8009990000');

INSERT INTO Products (ProductName, Description, Price, StockQuantity, SellerID, Category) VALUES
('Laptop', '15-inch business laptop', 75000.00, 20, 1, 'Electronics'),
('Wireless Mouse', 'Ergonomic wireless mouse', 1200.00, 100, 1, 'Electronics'),
('Sofa Set', '3-seater fabric sofa', 35000.00, 10, 2, 'Furniture'),
('Running Shoes', 'Men sports shoes', 4500.00, 50, 3, 'Fashion'),
('Novel Book', 'Bestselling fiction novel', 499.00, 200, 4, 'Books'),
('Smartphone', '5G Android smartphone', 28000.00, 30, 5, 'Electronics');

INSERT INTO Orders (CustomerID, TotalAmount, Status) VALUES
(1, 76200.00, 'Confirmed'),
(2, 35000.00, 'Shipped'),
(3, 499.00, 'Delivered'),
(4, 4500.00, 'Pending'),
(5, 29200.00, 'Confirmed');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 75000.00),
(1, 2, 1, 1200.00),
(2, 3, 1, 35000.00),
(3, 5, 1, 499.00),
(4, 4, 1, 4500.00),
(5, 6, 1, 28000.00),
(5, 2, 1, 1200.00);

INSERT INTO Payments (OrderID, PaymentMethod, Amount, PaymentStatus) VALUES
(1, 'Credit Card', 76200.00, 'Completed'),
(2, 'UPI', 35000.00, 'Completed'),
(3, 'Net Banking', 499.00, 'Completed'),
(4, 'Cash on Delivery', 4500.00, 'Pending'),
(5, 'Debit Card', 29200.00, 'Completed');

INSERT INTO Shipments (OrderID, Carrier, TrackingNumber, Status) VALUES
(1, 'BlueDart', 'BD123456', 'Shipped'),
(2, 'DTDC', 'DT789012', 'In Transit'),
(3, 'India Post', 'IP345678', 'Delivered'),
(4, 'Delhivery', 'DL901234', 'Processing'),
(5, 'Ecom Express', 'EE567890', 'Shipped');


CREATE VIEW SellerSalesSummary AS
SELECT
    s.SellerID,
    s.SellerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.Price) AS TotalSalesAmount,
    AVG(oi.Quantity * oi.Price) AS AverageOrderValue
FROM Sellers s
JOIN Products p ON s.SellerID = p.SellerID
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o ON oi.OrderID = o.OrderID
GROUP BY s.SellerID, s.SellerName;

SELECT * FROM SellerSalesSummary;

CREATE VIEW MonthlySalesTrend AS
SELECT
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS SalesMonth,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.Price) AS MonthlySalesAmount
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m');

SELECT * FROM MonthlySalesTrend;

SELECT 
    s.SellerID,
    s.SellerName,
    SUM(oi.Quantity * oi.Price) AS TotalRevenue,
    COUNT(DISTINCT o.OrderID) AS TotalOrders
FROM Sellers s
JOIN Products p ON s.SellerID = p.SellerID
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o ON oi.OrderID = o.OrderID
GROUP BY s.SellerID, s.SellerName
HAVING SUM(oi.Quantity * oi.Price) > 30000;

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(o.TotalAmount) AS TotalSpent,
    CASE
        WHEN SUM(o.TotalAmount) >= 50000 THEN 'Premium'
        WHEN SUM(o.TotalAmount) BETWEEN 10000 AND 49999 THEN 'Regular'
        ELSE 'Low Value'
    END AS CustomerCategory
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, CustomerName;

SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(oi.Quantity) >
      (SELECT AVG(Quantity) FROM OrderItems);
      
SELECT
    SellerID,
    SellerName,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM (
    SELECT
        s.SellerID,
        s.SellerName,
        SUM(oi.Quantity * oi.Price) AS TotalRevenue
    FROM Sellers s
    JOIN Products p ON s.SellerID = p.SellerID
    JOIN OrderItems oi ON p.ProductID = oi.ProductID
    GROUP BY s.SellerID, s.SellerName
) AS SellerRevenue;

DELIMITER $$

CREATE PROCEDURE GetMonthlySales(IN inputMonth VARCHAR(7))
BEGIN
    SELECT
        inputMonth AS SalesMonth,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        SUM(oi.Quantity * oi.Price) AS TotalSales
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE DATE_FORMAT(o.OrderDate, '%Y-%m') = inputMonth;
END $$

DELIMITER ;


CALL GetMonthlySales('2026-01');

SELECT
    s.SellerID,
    s.SellerName,
    SUM(oi.Quantity * oi.Price) AS TotalRevenue
FROM Sellers s
JOIN Products p ON s.SellerID = p.SellerID
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN CustomerAddresses ca ON o.CustomerID = ca.CustomerID
WHERE ca.City = 'Bangalore'
   OR ca.City = 'Mumbai'
   OR ca.City = 'Delhi'
   OR ca.City = 'Chennai'
GROUP BY s.SellerID, s.SellerName
ORDER BY TotalRevenue DESC;

-- Index for fast city filtering
CREATE INDEX idx_customer_city ON CustomerAddresses(City);

-- Indexes for join columns
CREATE INDEX idx_orders_customer ON Orders(CustomerID);
CREATE INDEX idx_orderitems_product ON OrderItems(ProductID);
CREATE INDEX idx_products_seller ON Products(SellerID);

SELECT
    s.SellerID,
    s.SellerName,
    SUM(oi.Quantity * oi.Price) AS TotalRevenue
FROM Sellers s
JOIN Products p ON s.SellerID = p.SellerID
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN (
    SELECT CustomerID
    FROM CustomerAddresses
    WHERE City IN ('Bangalore','Mumbai','Delhi','Chennai')
) AS ca_filtered ON o.CustomerID = ca_filtered.CustomerID
GROUP BY s.SellerID, s.SellerName
ORDER BY TotalRevenue DESC;
























