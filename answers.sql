
-- # Question 1
-- Achieving 1NF
/** I am going to use the Tally Table Method to normalize the data
 This transforms the ProductDetail table to 1NF by splitting Products column
 */

SELECT 
    p.OrderID,
    p.CustomerName,
    TRIM(SUBSTRING_INDEX(p.Products, ',', n.num), ',', -1) AS Product
    S Products
FROM 
    ProductDetail p
JOIN(

    -- NNumbers table for up to 10 products per order
    SELECT 1 AS num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL
    SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
) n 

-- Join condition to ensure we only get as many products as exist in the Products column
ON CHAR_LENGTH(p.Products) - CHAR_LENGTH(REPLACE(p.Products, ',', '')) >= n.num - 1
ORDER BY 
    p.OrderID, n.num;

-- # Question 2 
-- Achieving 2NF
/* 
To achieve 2NF, we need to remove partial dependencies from the table.
 This can be seen where the primary key is composite (OrderID, Product)
    and CustomerName depends only on OrderID.
    quantity dpeends on both OrderID and Product.

*/

-- Create Orders table to store OrderID and CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- create orderItems table with full depency on composite key
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

--inserting unique orders into orders tabele

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM ProductDetail;

-- inserting data into orderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;




