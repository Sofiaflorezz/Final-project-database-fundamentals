#CREACION DE VISTAS 
-- 1 This view displays a list of products available in the store catalog.
CREATE OR REPLACE VIEW ProductCatalogView AS
SELECT product_name, product_price, stock_quantity
FROM Product
ORDER BY product_name;
SELECT * FROM ProductCatalogView;

-- 2 This view shows completed orders 
CREATE OR REPLACE VIEW CompletedOrdersView AS
SELECT *
FROM Orderr
WHERE order_status = 'completed';
SELECT * FROM CompletedOrdersView;

-- 3 View for purchase history and customer preferences
CREATE OR REPLACE VIEW CustomerPurchaseHistoryView AS
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, oi.product_id, oi.quantity, oi.unit_price
FROM Customer c
JOIN Orderr o ON c.customer_id = o.customer_id
JOIN Ordered_Item oi ON o.order_id = oi.order_id;
SELECT * FROM CompletedOrdersView;

-- 4 View for sales reports and data analysis
CREATE OR REPLACE VIEW SalesReportsDataAnalysisView AS
SELECT o.order_id, o.order_date, oi.product_id, p.product_name, oi.quantity, oi.unit_price
FROM Orderr o
JOIN Ordered_Item oi ON o.order_id = oi.order_id
JOIN Product p ON oi.product_id = p.product_id;
SELECT * FROM SalesReportsDataAnalysisView;

-- 5 Low Inventory View
CREATE OR REPLACE VIEW LowInventory AS
SELECT product_id, product_name, stock_quantity
FROM Product
WHERE stock_quantity < 10;
SELECT * FROM LowInventory;

--  6 View of best-selling products
CREATE OR REPLACE VIEW TopSellingProducts AS
SELECT oi.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM Ordered_Item oi
JOIN Product p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY total_sold DESC;
SELECT * FROM TopSellingProducts;

-- 7 Monthly sales views 
CREATE OR REPLACE VIEW MonthlySalesSummary AS
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Orderr o
JOIN Ordered_Item oi ON o.order_id = oi.order_id
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year DESC, month DESC;
SELECT * FROM MonthlySalesSummary;

-- 8 View products by category 
CREATE OR REPLACE VIEW ProductsByCategory AS
SELECT p.product_id, p.product_name, c.category_name
FROM Product p
JOIN Category c ON p.category_id = c.category_id;
SELECT * FROM ProductsByCategory;

-- 9 Customer purchase history
CREATE OR REPLACE VIEW CustomerPurchaseHistory AS
SELECT o.order_id, o.order_date, p.product_id, p.product_name, oi.quantity, oi.unit_price
FROM Orderr o
JOIN Ordered_Item oi ON o.order_id = oi.order_id
JOIN Product p ON oi.product_id = p.product_id
WHERE o.customer_id = 2 ;
SELECT * FROM CustomerPurchaseHistory;

-- 10 Recommended products
CREATE OR REPLACE VIEW RecommendedProducts AS
SELECT p.product_id, p.product_name, p.product_price
FROM Product p
JOIN Ordered_Item oi ON p.product_id = oi.product_id
JOIN Orderr o ON oi.order_id = o.order_id
WHERE o.customer_id = 1
GROUP BY p.product_id, p.product_name, p.product_price
ORDER BY COUNT(*) DESC;
SELECT * FROM RecommendedProducts;

# CREATION OF PROCEDURES

-- 11. Procedure to insert a new order:
DELIMITER //
CREATE PROCEDURE Insertorder (
    IN costumer_id INT,
    IN product_id INT,
    IN amount INT
)
BEGIN
    INSERT INTO Orderr (customer_id, order_date, order_status)
    VALUES (cliente_id, NOW(), 'pendiente');
    SET @pedido_id = LAST_INSERT_ID();
    INSERT INTO Ordered_Item (order_id, product_id, quantity)
    VALUES (@pedido_id, producto_id, cantidad);
    UPDATE Product
    SET stock_quantity = stock_quantity - cantidad
    WHERE product_id = producto_id;
END //
DELIMITER ;


-- 12. Procedure to update the status of an order
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus (
    IN order_id INT,
    IN new_state VARCHAR(20)
)
BEGIN
    UPDATE Orderr
    SET order_status = nuevo_estado
    WHERE order_id = pedido_id;
END //
DELIMITER ;

-- 13. Procedure to obtain a customer's purchase history
DELIMITER //
CREATE PROCEDURE CustomerPurchaseHistory (
    IN customer_id INT
)
BEGIN
    SELECT o.order_id, o.order_date, p.product_id, p.product_name, oi.quantity, oi.unit_price
    FROM Orderr o
    JOIN Ordered_Item oi ON o.order_id = oi.order_id
    JOIN Product p ON oi.product_id = p.product_id
    WHERE o.customer_id = cliente_id;
END //
DELIMITER ;




-- 14. Procedure to cancel an order
DELIMITER //
CREATE PROCEDURE CancelOrder (
    IN order_id INT
)
BEGIN
    DECLARE producto_id INT;
    DECLARE cantidad INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR 
        SELECT product_id, quantity
        FROM Ordered_Item
        WHERE order_id = order_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO producto_id, cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE Product
        SET stock_quantity = stock_quantity + cantidad
        WHERE product_id = producto_id;
    END LOOP;
    CLOSE cur;
    DELETE FROM Orderr
    WHERE order_id = order_id;
END //
DELIMITER ;

-- 15. Procedure to update the stock quantity of a product

DELIMITER //
CREATE PROCEDURE UpdateStockQuantity (
    IN product_id INT,
    IN new_quantity INT
)
BEGIN
    UPDATE Product
    SET stock_quantity = new_quantity
    WHERE product_id = product_id;
END //
DELIMITER ;

-- 16. Procedure to calculate total sales for a customer

DELIMITER //
CREATE PROCEDURE CalculateTotalSales (
    IN customer_id INT,
    OUT total_sales FLOAT
)
BEGIN
    SELECT SUM(total_order) INTO total_sales
    FROM Orderr
    WHERE customer_id = customer_id;
END //
DELIMITER ;

-- 17. Procedure to obtain a customer's order history

DELIMITER //
CREATE PROCEDURE GetOrderHistory (
    IN customer_id INT
)
BEGIN
    SELECT *
    FROM Orderr
    WHERE customer_id = customer_id;
END //
DELIMITER ;

-- 18. Get details of a product

DELIMITER //
CREATE PROCEDURE GetProductDetails (
    IN product_id INT,
    OUT product_name VARCHAR(50),
    OUT price FLOAT,
    OUT stock_quantity INT
)
BEGIN
    SELECT product_name, product_price, stock_quantity
    INTO product_name, price, stock_quantity
    FROM Product
    WHERE product_id = product_id;
END //
DELIMITER ;

-- 19. Procedure to update the price of a product
DELIMITER //
CREATE PROCEDURE UpdateProductPrice (
    IN product_id INT,
    IN new_price FLOAT
)
BEGIN
    UPDATE Product
    SET product_price = new_price
    WHERE product_id = product_id;
END //
DELIMITER ;

-- 20. Procedure to update customer details

DELIMITER //
CREATE PROCEDURE UpdateCustomerDetails (
    IN customer_id INT,
    IN new_name VARCHAR(50),
    IN new_email VARCHAR(50)
)
BEGIN
    UPDATE Customer
    SET customer_name = new_name, customer_email = new_email
    WHERE customer_id = customer_id;
END //
DELIMITER ;
-- 21.Procedure to add a new product
DELIMITER //
CREATE PROCEDURE AddNewProduct (
    IN product_name VARCHAR(50),
    IN product_price FLOAT,
    IN stock_quantity INT,
    IN category_id INT
)
BEGIN
    INSERT INTO Product (product_name, product_price, stock_quantity, category_id)
    VALUES (product_name, product_price, stock_quantity, category_id);
END //
DELIMITER ;

# TRIGGERS
-- Trigger 22: Notify manager when a new order is placed

DELIMITER //
CREATE TRIGGER NotifyManagerOnNewOrder
AFTER INSERT ON Orderr
FOR EACH ROW
BEGIN
    DECLARE manager_email VARCHAR(100);
    -- Obtener el correo electrónico del gerente (asumiendo que está almacenado en alguna tabla)
    SELECT email INTO manager_email FROM Manager WHERE manager_id = 1;

    -- Enviar correo electrónico de notificación al gerente
    INSERT INTO Notification (recipient_email, subject, message)
    VALUES (manager_email, 'Nuevo pedido realizado', CONCAT('Se ha realizado un nuevo pedido con el ID: ', NEW.order_id));
END //
DELIMITER ;

-- Trigger 23: Update inventory after completing an order
DELIMITER //
CREATE TRIGGER UpdateInventoryOnOrderCompletion
AFTER UPDATE ON Orderr
FOR EACH ROW
BEGIN
    -- Verificar si el estado del pedido ha cambiado a completado
    IF NEW.order_status = 'completed' AND OLD.order_status <> 'completed' THEN
        -- Actualizar el inventario
        UPDATE Product p
        JOIN Ordered_Item oi ON p.product_id = oi.product_id
        SET p.stock_quantity = p.stock_quantity - oi.quantity
        WHERE oi.order_id = NEW.order_id;
    END IF;
END //
DELIMITER ;

-- Trigger 24: Registro de cambios en el historial de pedidos
DELIMITER //
CREATE TRIGGER OrderHistoryLog
AFTER UPDATE ON Orderr
FOR EACH ROW
BEGIN
    INSERT INTO OrderHistory (order_id, old_status, new_status, change_date)
    VALUES (OLD.order_id, OLD.order_status, NEW.order_status, NOW());
END //
DELIMITER ;

-- Trigger 24: Update order total when inserting new order items
DELIMITER //
CREATE TRIGGER UpdateOrderTotalOnInsert
AFTER INSERT ON Ordered_Item
FOR EACH ROW
BEGIN
    UPDATE Orderr
    SET total_order = total_order + (NEW.quantity * NEW.unit_price)
    WHERE order_id = NEW.order_id;
END //
DELIMITER ;

-- Trigger 25: Restriction of deletion of customers with associated orders
DELIMITER //
CREATE TRIGGER PreventCustomerDeletion
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
    DECLARE orders_count INT;
    SELECT COUNT(*) INTO orders_count
    FROM Orderr
    WHERE customer_id = OLD.customer_id;
    IF orders_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar este cliente debido a que tiene pedidos asociados';
    END IF;
END //
DELIMITER ;

# NESTED SELECT
-- 26 Select products whose price is higher than the pro price
SELECT product_id, product_name, product_price
FROM Product
WHERE product_price > (
    -- Calcula el precio promedio de todos los productos.
    SELECT AVG(product_price)
    FROM Product
);

-- 27  Select products that are priced higher than the average price of all products in the store.
SELECT product_id, product_name, product_price
FROM Product
WHERE product_price > (
    SELECT AVG(product_price)
    FROM Product
);

-- 28 Update the stock of products that have been sold in the last month.
UPDATE Product
SET stock_quantity = stock_quantity - (
    SELECT SUM(quantity)
    FROM Ordered_Item oi
    JOIN Orderr o ON oi.order_id = o.order_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
        AND oi.product_id = Product.product_id
)
WHERE product_id = 123; 

-- 29 Gets the customer's name and the total spent on their last purchase.
SELECT
    c.customer_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM Customer c
LEFT JOIN Orderr o ON o.customer_id = c.customer_id
LEFT JOIN Ordered_Item oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;


