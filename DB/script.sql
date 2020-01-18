-- -----------------------------------------------------
-- Schema PUBify
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS PUBify;
CREATE SCHEMA PUBify DEFAULT CHARSET = utf8mb4;
USE PUBify;

-- -----------------------------------------------------
-- Table Buyable
-- -----------------------------------------------------
CREATE TABLE Buyable (
    idProduct     INT UNSIGNED,
    price         DOUBLE UNSIGNED NOT NULL,
    startSaleDate DATETIME        NOT NULL,
    endSaleDate   DATETIME        NULL,
    CONSTRAINT PK_Buyable PRIMARY KEY (idProduct)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Buyable_CustomerOrder
-- -----------------------------------------------------
CREATE TABLE Buyable_CustomerOrder (
    idBuyable       INT UNSIGNED,
    idCustomerOrder INT UNSIGNED,
    price           DOUBLE UNSIGNED   NOT NULL,
    quantity        SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT PK_Buyable_CustomerOrder PRIMARY KEY (idBuyable, idCustomerOrder)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table CustomerOrder
-- -----------------------------------------------------
CREATE TABLE CustomerOrder (
    idOrder  INT UNSIGNED,
    idWaiter INT UNSIGNED      NOT NULL,
    tableNB  SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT PK_CustomerOrder PRIMARY KEY (idOrder)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Drink
-- -----------------------------------------------------
CREATE TABLE Drink (
    idBuyable    INT UNSIGNED,
    alcoholLevel DECIMAL(3, 1) NOT NULL,
    CONSTRAINT PK_Drink PRIMARY KEY (idBuyable)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Drink_HappyHour
-- -----------------------------------------------------
CREATE TABLE Drink_HappyHour (
    idDrink          INT UNSIGNED NOT NULL,
    startAtHappyHour DATETIME     NOT NULL,
    PRIMARY KEY (startAtHappyHour, idDrink)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Food
-- -----------------------------------------------------
CREATE TABLE Food (
    idBuyable INT UNSIGNED,
    CONSTRAINT PK_Food PRIMARY KEY (idBuyable)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Food_Ingredient
-- -----------------------------------------------------
CREATE TABLE Food_Ingredient (
    idFood       INT UNSIGNED,
    idIngredient INT UNSIGNED,
    quantity     SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT PK_Food_Ingredient PRIMARY KEY (idFood, idIngredient)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table HappyHour
-- -----------------------------------------------------
CREATE TABLE HappyHour (
	startAt          DATETIME,
    idManager        INT UNSIGNED NOT NULL,
    duration         TIME         NOT NULL,
    reductionPercent INT UNSIGNED NOT NULL,
    CONSTRAINT PK_HappyHour PRIMARY KEY (startAt)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ingredient
-- -----------------------------------------------------
CREATE TABLE Ingredient (
    idProduct INT UNSIGNED,
    CONSTRAINT PK_Ingredient PRIMARY KEY (idProduct)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Manager
-- -----------------------------------------------------
CREATE TABLE Manager (
    idStaff INT UNSIGNED,
    active  BOOLEAN NOT NULL DEFAULT 1,
    CONSTRAINT PK_Manager PRIMARY KEY (idStaff)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Order
-- -----------------------------------------------------
CREATE TABLE `Order` (
    id      INT UNSIGNED AUTO_INCREMENT,
    orderAt DATETIME        NOT NULL,
    tva     DOUBLE UNSIGNED NOT NULL,
    CONSTRAINT PK_Order PRIMARY KEY (id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Product
-- -----------------------------------------------------
CREATE TABLE Product (
    id             INT UNSIGNED AUTO_INCREMENT,
    name           VARCHAR(100) NOT NULL,
    nameUnitMetric VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY (id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Product_SupplyOrder
-- -----------------------------------------------------
CREATE TABLE Product_SupplyOrder (
    idProduct     INT UNSIGNED,
    idSupplyOrder INT UNSIGNED,
    price         DOUBLE UNSIGNED NOT NULL,
    quantity      INT UNSIGNED    NOT NULL,
    CONSTRAINT PK_Product_SupplyOrder PRIMARY KEY (idProduct, idSupplyOrder)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Staff
-- -----------------------------------------------------
CREATE TABLE Staff (
    id       INT UNSIGNED AUTO_INCREMENT,
    email    VARCHAR(255) NOT NULL,
    name     VARCHAR(45)  NOT NULL,
    lastname VARCHAR(45)  NOT NULL,
    password VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Staff PRIMARY KEY (id),
    CONSTRAINT UC_Staff_email UNIQUE (email)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Stock
-- -----------------------------------------------------
CREATE TABLE Stock (
    id        INT UNSIGNED AUTO_INCREMENT,
    quantity  INT UNSIGNED        NOT NULL,
    idProduct INT UNSIGNED UNIQUE NOT NULL,
    CONSTRAINT PK_Stock PRIMARY KEY (id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Supplier
-- -----------------------------------------------------
CREATE TABLE Supplier (
    id   INT UNSIGNED AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    CONSTRAINT PK_Supplier PRIMARY KEY (id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table SupplyOrder
-- -----------------------------------------------------
CREATE TABLE SupplyOrder (
    idOrder    INT UNSIGNED,
    idSupplier INT UNSIGNED NOT NULL,
    idManager  INT UNSIGNED NOT NULL,
    CONSTRAINT PK_SupplyOrder PRIMARY KEY (idOrder)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table UnitMetric
-- -----------------------------------------------------
CREATE TABLE UnitMetric (
    name      VARCHAR(20),
    shortName VARCHAR(3) NOT NULL,
    CONSTRAINT PK_UnitMetric PRIMARY KEY (name)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Waiter
-- -----------------------------------------------------
CREATE TABLE Waiter (
    idStaff INT UNSIGNED,
    active  BOOLEAN NOT NULL DEFAULT 1,
    CONSTRAINT PK_Waiter PRIMARY KEY (idStaff)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Foreign Keys
-- -----------------------------------------------------
ALTER TABLE Buyable
    ADD CONSTRAINT FK_Buyable_idProduct
        FOREIGN KEY (idProduct)
            REFERENCES Product (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Buyable_CustomerOrder
    ADD INDEX FK_CustomerOrder_Buyable_idOrderCustomerOrder_idx (idCustomerOrder ASC),
    ADD CONSTRAINT FK_Buyable_CustomerOrder_idCustomerOrder
        FOREIGN KEY (idCustomerOrder)
            REFERENCES CustomerOrder (idOrder)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD INDEX FK_Buyable_CustomerOrder_idPBuyable_idx (idBuyable ASC),
    ADD CONSTRAINT FK_Buyable_CustomerOrder_idBuyable
        FOREIGN KEY (idBuyable)
            REFERENCES Buyable (idProduct)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE CustomerOrder
    ADD CONSTRAINT FK_CustomerOrder_idOrder
        FOREIGN KEY (idOrder)
            REFERENCES `Order` (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD INDEX FK_CustomerOrder_idWaiter_idx (idWaiter ASC),
    ADD CONSTRAINT FK_CustomerOrder_idWaiter
        FOREIGN KEY (idWaiter)
            REFERENCES Waiter (idStaff)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Drink
    ADD CONSTRAINT FK_Drink_idBuyable
        FOREIGN KEY (idBuyable)
            REFERENCES Buyable (idProduct)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;


ALTER TABLE Drink_HappyHour
    ADD INDEX FK_HappyHour_Drink_idDrink_idx (idDrink ASC),
    ADD CONSTRAINT FK_Drink_HappyHour_idBuyableDrink
        FOREIGN KEY (idDrink)
            REFERENCES Drink (idBuyable)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD INDEX FK_HappyHour_Drink_idHappyHour_idx (startAtHappyHour ASC),
    ADD CONSTRAINT FK_Drink_HappyHour_idHappyHour
        FOREIGN KEY (startAtHappyHour)
            REFERENCES HappyHour (startAt)
            ON DELETE CASCADE
            ON UPDATE CASCADE;


ALTER TABLE Food
    ADD CONSTRAINT FK_Food_idBuyable
        FOREIGN KEY (idBuyable)
            REFERENCES Buyable (idProduct)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Food_Ingredient
    ADD INDEX FK_Food_Ingredient_idIngredient_idx (idIngredient ASC),
    ADD CONSTRAINT FK_Food_Ingredient_idFood
        FOREIGN KEY (idFood)
            REFERENCES Food (idBuyable)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD INDEX FK_Food_Ingredient_idFood_idx (idFood ASC),
    ADD CONSTRAINT FK_Food_Ingredient_idIngredient
        FOREIGN KEY (idIngredient)
            REFERENCES Ingredient (idProduct)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE HappyHour
    ADD INDEX FK_Manager_Drink_idManager_idx (idManager ASC),
    ADD CONSTRAINT FK_HappyHour_idManager
        FOREIGN KEY (idManager)
            REFERENCES Manager (idStaff)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Ingredient
    ADD CONSTRAINT FK_Ingredient_idProduct
        FOREIGN KEY (idProduct)
            REFERENCES Product (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Manager
    ADD CONSTRAINT FK_Manager_idStaff
        FOREIGN KEY (idStaff)
            REFERENCES Staff (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Product
    ADD INDEX FK_Product_nameUnitMetrics_idx (nameUnitMetric ASC),
    ADD CONSTRAINT FK_Product_nameUnitMetric
        FOREIGN KEY (nameUnitMetric)
            REFERENCES UnitMetric (name)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Product_SupplyOrder
    ADD INDEX FK_SupplyOrder_Product_idProduct_idx (idProduct ASC),
    ADD CONSTRAINT FK_Product_SupplyOrder_idSupplyOrder
        FOREIGN KEY (idSupplyOrder)
            REFERENCES SupplyOrder (idOrder)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD INDEX FK_SupplyOrder_Product_idOrderSupplyOrder_idx (idSupplyOrder ASC),
    ADD CONSTRAINT FK_Product_SupplyOrder_idProduct
        FOREIGN KEY (idProduct)
            REFERENCES Product (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Stock
    ADD INDEX FK_Stock_idProduct_idx (idProduct ASC),
    ADD CONSTRAINT FK_Stock_idProduct
        FOREIGN KEY (idProduct)
            REFERENCES Product (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE SupplyOrder
    ADD CONSTRAINT FK_SupplyOrder_idOrder
        FOREIGN KEY (idOrder)
            REFERENCES `Order` (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    ADD INDEX FK_SupplyOrder_idSupplier_idx (idSupplier ASC),
    ADD CONSTRAINT FK_SupplyOrder_idSupplier
        FOREIGN KEY (idSupplier)
            REFERENCES Supplier (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
    ADD INDEX FK_SupplyOrder_idManager_idx (idManager ASC),
    ADD CONSTRAINT FK_SupplyOrder_idManager
        FOREIGN KEY (idManager)
            REFERENCES Manager (idStaff)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;

ALTER TABLE Waiter
    ADD CONSTRAINT FK_Waiter_idStaff
        FOREIGN KEY (idStaff)
            REFERENCES Staff (id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE;DROP VIEW IF EXISTS vActiveStaff;
CREATE VIEW vActiveStaff
AS
SELECT Staff.id,
       Staff.email,
       Staff.name,
       Staff.lastname,
       Staff.password
FROM Staff 
    INNER JOIN Waiter
        ON Staff.id = Waiter.idStaff
WHERE active = 1
UNION
SELECT Staff.id,
       Staff.email,
       Staff.name,
       Staff.lastname,
       Staff.password
FROM Staff
    INNER JOIN Manager
        ON Staff.id = Manager.idStaff
WHERE active = 1;

DROP VIEW IF EXISTS vWaiter;
CREATE VIEW vWaiter
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email,
       Waiter.active
FROM Waiter
    INNER JOIN Staff
        ON Staff.id = Waiter.idStaff;

DROP VIEW IF EXISTS vManager;
CREATE VIEW vManager
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email,
       Manager.active
FROM Manager
    INNER JOIN Staff
        ON Staff.id = Manager.idStaff;

DROP VIEW IF EXISTS vCustomerOrder;
CREATE VIEW vCustomerOrder
AS
SELECT `Order`.id,
       `Order`.orderAt,
       CustomerOrder.tableNB,
       vWaiter.name,
       vWaiter.lastname,
       `Order`.tva
FROM CustomerOrder
    INNER JOIN `Order`
        ON `Order`.id = CustomerOrder.idOrder
    INNER JOIN vWaiter
        ON vWaiter.id = CustomerOrder.idWaiter;

DROP VIEW IF EXISTS vSupplyOrder;
CREATE VIEW vSupplyOrder
AS
SELECT `Order`.id,
       `Order`.orderAt,
       vManager.name     AS manager_name,
       vManager.lastname AS manager_lastname,
       Supplier.name     AS supplier_name,
       `Order`.tva
FROM SupplyOrder
    INNER JOIN `Order`
        ON `Order`.id = SupplyOrder.idOrder
    INNER JOIN vManager
        ON vManager.id = SupplyOrder.idManager
    INNER JOIN Supplier
        ON SupplyOrder.idSupplier = Supplier.id;

DROP VIEW IF EXISTS vProduct;
CREATE VIEW vProduct
AS
SELECT Product.id,
       Product.name         AS product_name,
       UnitMetric.name      AS unit_name,
       UnitMetric.shortName AS unit_shortName
FROM Product
    INNER JOIN UnitMetric
        ON Product.nameUnitMetric = UnitMetric.name;

DROP VIEW IF EXISTS vStockableProduct;
CREATE VIEW vStockableProduct
AS
SELECT vProduct.*,
       Stock.quantity
FROM vProduct
    RIGHT JOIN Stock
        ON vProduct.id = Stock.idProduct;

DROP VIEW IF EXISTS vBuyable;
CREATE VIEW vBuyable
AS
SELECT vProduct.*,
       Buyable.price,
       Buyable.startSaleDate,
       Buyable.endSaleDate
FROM Buyable
    INNER JOIN vProduct
        ON vProduct.id = Buyable.idProduct;

DROP VIEW IF EXISTS vStockableBuyable;
CREATE VIEW vStockableBuyable
AS
SELECT vBuyable.*,
       Stock.quantity
FROM vBuyable
    INNER JOIN Stock
        ON vBuyable.id = Stock.idProduct;

DROP VIEW IF EXISTS vDrink;
CREATE VIEW vDrink
AS
SELECT vStockableBuyable.*,
       Drink.alcoholLevel
FROM Drink
    INNER JOIN vStockableBuyable
        ON Drink.idBuyable = vStockableBuyable.id;

DROP VIEW IF EXISTS vStockableFood;
CREATE VIEW vStockableFood
AS
SELECT vStockableBuyable.*
FROM Food
    INNER JOIN vStockableBuyable
        ON Food.idBuyable = vStockableBuyable.id;
        
DROP VIEW IF EXISTS vNonstockableFood;
CREATE VIEW vNonstockableFood
AS
SELECT
    vBuyable.*,
    CAST(FLOOR(MIN(Stock.quantity / Food_Ingredient.quantity)) AS UNSIGNED) AS quantity
FROM Food
    INNER JOIN Food_Ingredient
        ON Food_Ingredient.idFood = Food.idBuyable
    INNER JOIN Stock
        ON Food_Ingredient.idIngredient = Stock.idProduct
    INNER JOIN vBuyable
        ON vBuyable.id = Food.idBuyable
GROUP BY Food.idBuyable;

DROP VIEW IF EXISTS vFood;
CREATE VIEW vFood
AS
SELECT *
FROM vStockableFood
UNION
SELECT *
FROM vNonstockableFood;

DROP VIEW IF EXISTS vIngredient;
CREATE VIEW vIngredient
AS
SELECT vStockableProduct.*
FROM vStockableProduct
    INNER JOIN Ingredient
        ON Ingredient.idProduct = vStockableProduct.id;
USE PUBify;

DELIMITER $$

-- ------------------------------------ --
-- GENERAL USAGE PROCEDURES n FUNCTIONS --
-- ------------------------------------ --

DROP FUNCTION IF EXISTS within_range_int $$
CREATE FUNCTION within_range_int(min INT, max INT, value INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN IF(value BETWEEN min AND max, TRUE, FALSE);
END $$

DROP FUNCTION IF EXISTS within_range_decimal $$
CREATE FUNCTION within_range_decimal(min DECIMAL, max DECIMAL, value DECIMAL)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN IF(value BETWEEN min AND max, TRUE, FALSE);
END $$

DROP FUNCTION IF EXISTS within_range_datetime $$
CREATE FUNCTION within_range_datetime(min DATETIME, max DATETIME, value DATETIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN IF(min <= value && (max IS NULL OR max >= value), TRUE, FALSE);
END $$

DROP PROCEDURE IF EXISTS send_exception $$
CREATE PROCEDURE send_exception(errorDescription VARCHAR(255))
BEGIN
    -- return an `unhandeled used-defined exception`
    -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = errorDescription;
END $$

-- ------------------------------- --
-- SPECIFIC PROCEDURES n FUNCTIONS --
-- ------------------------------- --

/* DRINK */
DROP PROCEDURE IF EXISTS validate_alcohol_level $$
CREATE PROCEDURE validate_alcohol_level(alcohol_level DECIMAL)
BEGIN
    DECLARE max_alcohol_level INT DEFAULT 100;
    DECLARE min_alcohol_level INT DEFAULT 0;

    IF NOT within_range_decimal(min_alcohol_level, max_alcohol_level, alcohol_level) THEN
        CALL send_exception('Alcohol level can\'t be negative!');
    END IF;
END $$

/* HAPPY HOUR */
DROP PROCEDURE IF EXISTS validate_happy_hour_reduction $$
CREATE PROCEDURE validate_happy_hour_reduction(reduction INT)
BEGIN
    DECLARE max_reduction_percent INT DEFAULT 100;
    DECLARE min_reduction_percent INT DEFAULT 1;

    IF NOT within_range_int(min_reduction_percent, max_reduction_percent, reduction) THEN
        CALL send_exception('The reduction percent must be within 1 and 100');
    END IF;
END $$

DROP PROCEDURE IF EXISTS validate_happy_hour_duration $$
CREATE PROCEDURE validate_happy_hour_duration(duration TIME)
BEGIN
    IF duration < 0 THEN
        CALL send_exception('The duration of a Happy Hour can\'t be negative!');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_happy_hour_not_overlapping $$
CREATE PROCEDURE check_happy_hour_not_overlapping(new_startAt DATETIME, new_duration TIME, old_startAt DATETIME)
BEGIN
    DECLARE nb_overlapping INT;
    SET nb_overlapping = (
        # Try and find any happy hours that overlap w/ the being inserted
        SELECT COUNT(*) FROM HappyHour
        WHERE startAt != old_startAt AND
              (new_startAt BETWEEN startAt AND ADDTIME(startAt, duration) OR
              startAt BETWEEN new_startAt AND ADDTIME(new_startAt, new_duration))
        );

    IF nb_overlapping > 0 THEN
        CALL send_exception('Happy hours can\'t be overlapping');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_product_not_composed $$
CREATE PROCEDURE check_product_not_composed(idProduct INT)
BEGIN
    -- Check that the product has ingredients
    IF (SELECT COUNT(*) FROM Food_Ingredient WHERE idFood = idProduct) > 0 THEN
        CALL send_exception('Composed products can\'t be stocked!');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_quantity_not_zero $$
CREATE PROCEDURE check_quantity_not_zero(quantity INT)
BEGIN
    IF quantity <= 0 THEN
        CALL send_exception('The quantity can\'t be 0 or lower');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_start_sale_before_end_sale $$
CREATE PROCEDURE check_start_sale_before_end_sale(`start` DATETIME, `end` DATETIME)
BEGIN
    IF `start` > `end` THEN
        CALL send_exception('Starting sale date can\'t be greater than the ending date');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_product_available $$
CREATE PROCEDURE check_product_available(`date` DATETIME, idBuyable INT)
BEGIN
    DECLARE start_buyable_sale DATETIME;
    DECLARE end_buyable_sale DATETIME;

    SET start_buyable_sale = (
        SELECT startSaleDate
        FROM Buyable
        WHERE idProduct = idBuyable
    );

    SET end_buyable_sale = (
        SELECT endSaleDate
        FROM Buyable
        WHERE idProduct = idBuyable
    );

    if NOT (within_range_datetime(start_buyable_sale, end_buyable_sale, `date`) AND
           within_range_datetime(start_buyable_sale, end_buyable_sale, `date`)) THEN
        CALL send_exception('Product unavailable');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_drink_available_during_happy_hour $$
CREATE PROCEDURE check_drink_available_during_happy_hour(startAtHappyHour DATETIME, idDrink INT)
BEGIN
    DECLARE happy_hour_duration TIME;

    SET happy_hour_duration = (
        SELECT duration
        FROM HappyHour
        WHERE startAt = startAtHappyHour
    );

    CALL check_product_available(startAtHappyHour, idDrink);
    CALL check_product_available(ADDTIME(startAtHappyHour, happy_hour_duration), idDrink);
END $$

DROP PROCEDURE IF EXISTS check_buyable_not_ingredient $$
CREATE PROCEDURE check_buyable_not_ingredient(idBuyable INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Ingredient
        WHERE Ingredient.idProduct = idBuyable
    ) > 0 THEN
        CALL send_exception('An Ingredient can\'t be a Buyable');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_ingredient_not_buyable $$
CREATE PROCEDURE check_ingredient_not_buyable(idIngredient INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Buyable
        WHERE Buyable.idProduct = idIngredient
    ) > 0 THEN
        CALL send_exception('A Buyable can\'t be an Ingredient');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_drink_not_food $$
CREATE PROCEDURE check_drink_not_food(idDrink INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Food
        WHERE Food.idBuyable = idDrink
    ) > 0 THEN
        CALL send_exception('A Food can\'t be a Drink');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_food_not_drink $$
CREATE PROCEDURE check_food_not_drink(idFood INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Drink
        WHERE Drink.idBuyable = idFood
    ) > 0 THEN
        CALL send_exception('A Drink can\'t be a Food');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_customer_order_not_supply_order $$
CREATE PROCEDURE check_customer_order_not_supply_order(idCustomerOrder INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM SupplyOrder
        WHERE SupplyOrder.idOrder = idCustomerOrder
    ) > 0 THEN
        CALL send_exception('A CustomerOrder can\'t be a SupplyOrder');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_supply_order_not_customer_order $$
CREATE PROCEDURE check_supply_order_not_customer_order(idSupplyOrder INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM CustomerOrder
        WHERE CustomerOrder.idOrder = idSupplyOrder
    ) > 0 THEN
        CALL send_exception('A SupplyOrder can\'t be a CustomerOrder');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_staff_is_active $$
CREATE PROCEDURE check_staff_is_active(idStaff INT)
BEGIN
    IF (SELECT id FROM vActiveStaff WHERE id = idStaff) IS NULL THEN
        CALL send_exception('A deleted staff can\'t perform any actions');
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_not_composed_food $$
CREATE PROCEDURE check_not_composed_food(idFood INT)
BEGIN
    IF (
        SELECT quantity
        FROM Stock
        WHERE idProduct = idFood
    ) > 0 THEN
        CALL send_exception('A stockable Food can\'t have Ingredients');
    END IF;
END $$

DELIMITER ;

DELIMITER $$
-- -----------------------------------------------
-- AFTER Triggers
-- -----------------------------------------------
DROP TRIGGER IF EXISTS after_buyable_customer_order_delete $$
CREATE TRIGGER after_buyable_customer_order_delete
    AFTER DELETE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE ingredient_id INT;
    DECLARE used_quantity INT;

    -- declare cursor for the buyables ingredients
    DECLARE cur_ingredient
        CURSOR FOR (
            SELECT Food_Ingredient.idIngredient
            FROM Food_Ingredient
            WHERE Food_Ingredient.idFood = OLD.idBuyable
        );

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- check if the affected product is stockable
    -- or if it's composed of ingredients
    IF (
        SELECT id
        FROM Stock
        WHERE idProduct = OLD.idBuyable
    ) IS NOT NULL THEN
        -- it's a stockable then the stock can be directly updated
        UPDATE Stock
        SET Stock.quantity = (Stock.quantity + OLD.quantity)
        WHERE idProduct = OLD.idBuyable;
    ELSE
        -- it's composed, so we need to update all of it's ingredients
        OPEN cur_ingredient;

        -- loop through all the ingredients
        updateIngredientStock: LOOP
            FETCH cur_ingredient INTO ingredient_id;
            IF finished = 1 THEN
                LEAVE updateIngredientStock;
            END IF;

            -- get the quantity used of the current ingredient
            SET used_quantity = (
                SELECT quantity
                FROM Food_Ingredient
                WHERE idFood = OLD.idBuyable AND
                        idIngredient = ingredient_id
            );

            -- update current ingredient stock
            UPDATE Stock
            SET Stock.quantity = (Stock.quantity + used_quantity * OLD.quantity)
            WHERE idProduct = ingredient_id;
        END LOOP;

        CLOSE cur_ingredient;
    END IF;
END $$

DROP TRIGGER IF EXISTS after_buyable_customer_order_insert $$
CREATE TRIGGER after_buyable_customer_order_insert
    AFTER INSERT ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE ingredient_id INT;
    DECLARE used_quantity INT;

    -- declare cursor for the buyables ingredients
    DECLARE cur_ingredient
        CURSOR FOR (
            SELECT Food_Ingredient.idIngredient
            FROM Food_Ingredient
            WHERE Food_Ingredient.idFood = NEW.idBuyable
        );

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

    -- check if the affected product is stockable
    -- or if it's composed of ingredients
    IF (
        SELECT id
        FROM Stock
        WHERE idProduct = NEW.idBuyable
    ) IS NOT NULL THEN
        -- it's a stockable then the stock can be directly updated
        UPDATE Stock
        SET Stock.quantity = (Stock.quantity - NEW.quantity)
        WHERE idProduct = NEW.idBuyable;
    ELSE
        -- it's composed, so we need to update all of it's ingredients
        OPEN cur_ingredient;

        -- loop through all the ingredients
        updateIngredientStock: LOOP
            FETCH cur_ingredient INTO ingredient_id;
            IF finished = 1 THEN
                LEAVE updateIngredientStock;
            END IF;

            -- get the quantity used of the current ingredient
            SET used_quantity = (
                SELECT quantity
                FROM Food_Ingredient
                WHERE idFood = NEW.idBuyable AND
                        idIngredient = ingredient_id
            );

            -- update current ingredient stock
            UPDATE Stock
            SET Stock.quantity = (Stock.quantity - used_quantity * NEW.quantity)
            WHERE idProduct = ingredient_id;
        END LOOP;

        CLOSE cur_ingredient;
    END IF;
END $$

DROP TRIGGER IF EXISTS after_customer_order_delete $$
CREATE TRIGGER after_customer_order_delete
    AFTER DELETE ON CustomerOrder
    FOR EACH ROW
BEGIN
    DELETE FROM `Order`
    WHERE id = OLD.idOrder;
END $$

DROP TRIGGER IF EXISTS after_product_supply_order_delete $$
CREATE TRIGGER after_product_supply_order_delete
    AFTER DELETE ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    UPDATE Stock
    SET quantity = quantity - OLD.quantity
    WHERE idProduct = OLD.idProduct;
END $$

DROP TRIGGER IF EXISTS after_product_supply_order_insert $$
CREATE TRIGGER after_product_supply_order_insert
    AFTER INSERT ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    UPDATE Stock
    SET quantity = quantity + NEW.quantity
    WHERE idProduct = NEW.idProduct;
END $$

DROP TRIGGER IF EXISTS after_supply_order_delete $$
CREATE TRIGGER after_supply_order_delete
    AFTER DELETE ON SupplyOrder
    FOR EACH ROW
BEGIN
    DELETE FROM `Order`
    WHERE id = OLD.idOrder;
END $$

-- -----------------------------------------------
-- BEFORE Triggers
-- -----------------------------------------------
DROP TRIGGER IF EXISTS before_buyable_delete $$
CREATE TRIGGER before_buyable_delete
    BEFORE DELETE ON Buyable
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Buyable');
END $$

DROP TRIGGER IF EXISTS before_buyable_insert $$
CREATE TRIGGER before_buyable_insert
    BEFORE INSERT ON Buyable
    FOR EACH ROW
BEGIN
    CALL check_buyable_not_ingredient(NEW.idProduct);
    CALL check_start_sale_before_end_sale(NEW.startSaleDate, NEW.endSaleDate);
END $$

DROP TRIGGER IF EXISTS before_buyable_update $$
CREATE TRIGGER before_buyable_update
    BEFORE UPDATE ON Buyable
    FOR EACH ROW
BEGIN
    CALL check_buyable_not_ingredient(NEW.idProduct);
    CALL check_start_sale_before_end_sale(NEW.startSaleDate, NEW.endSaleDate);
END $$

DROP TRIGGER IF EXISTS before_buyable_customer_order_delete $$
CREATE TRIGGER before_buyable_customer_order_delete
    BEFORE DELETE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    IF (
           SELECT COUNT(*)
           FROM Buyable_CustomerOrder
           WHERE idCustomerOrder = OLD.idCustomerOrder
       ) = 1 THEN
        CALL send_exception('There needs to be at least one product per customer order!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_buyable_customer_order_insert $$
CREATE TRIGGER before_buyable_customer_order_insert
    BEFORE INSERT ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    DECLARE stock_id INT;
    DECLARE error BOOLEAN;
    DECLARE order_date DATETIME;

    CALL check_quantity_not_zero(NEW.quantity);

    SET order_date = (
        SELECT orderAt
        FROM `Order`
        WHERE id = NEW.idCustomerOrder
    );

    CALL check_product_available(order_date, NEW.idBuyable);

    SET stock_id = (
        SELECT id
        FROM Stock
        WHERE idProduct = NEW.idBuyable
    );
    SET error = false;

    -- Check if there is enough stock for the wanted Buyable
    IF stock_id IS NULL THEN
        -- The product is composed of ingredients, so we need to check each ingredient
        IF (
            SELECT COUNT(*)
            FROM Food_Ingredient
                     INNER JOIN Stock
                                ON Food_Ingredient.idIngredient = Stock.idProduct
            WHERE Food_Ingredient.idFood = NEW.idBuyable AND
                    Stock.quantity < Food_Ingredient.quantity * NEW.quantity
        ) THEN
            SET error = true;
        END IF;
    ELSE
        IF (SELECT quantity FROM Stock WHERE id = stock_id) < NEW.quantity THEN
            SET error = true;
        END IF;
    END IF;

    IF error = true THEN
        CALL send_exception('Not enough stock for the order');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_buyable_customer_order_update $$
CREATE TRIGGER before_buyable_customer_order_update
    BEFORE UPDATE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    CALL send_exception('UPDATE query not allowed on Buyable_CustomerOrder');
END $$

DROP TRIGGER IF EXISTS before_customer_order_insert $$
CREATE TRIGGER before_customer_order_insert
    BEFORE INSERT ON CustomerOrder
    FOR EACH ROW
BEGIN
    CALL check_customer_order_not_supply_order(NEW.idOrder);
    CALL check_staff_is_active(NEW.idWaiter);
END $$

DROP TRIGGER IF EXISTS before_customer_order_update $$
CREATE TRIGGER before_customer_order_update
    BEFORE UPDATE ON CustomerOrder
    FOR EACH ROW
BEGIN
    CALL check_customer_order_not_supply_order(NEW.idOrder);
    CALL check_staff_is_active(NEW.idWaiter);
END $$

DROP TRIGGER IF EXISTS before_drink_delete $$
CREATE TRIGGER before_drink_delete
    BEFORE DELETE ON Drink
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Drink');
END $$

DROP TRIGGER IF EXISTS before_drink_insert $$
CREATE TRIGGER before_drink_insert
BEFORE INSERT ON Drink
FOR EACH ROW
BEGIN
    CALL check_drink_not_food(NEW.idBuyable);
    CALL validate_alcohol_level(NEW.alcoholLevel);
END $$

DROP TRIGGER IF EXISTS before_drink_update $$
CREATE TRIGGER before_drink_update
BEFORE UPDATE ON Drink
FOR EACH ROW
BEGIN
    CALL check_drink_not_food(NEW.idBuyable);
    CALL validate_alcohol_level(NEW.alcoholLevel);
END $$

DROP TRIGGER IF EXISTS before_drink_happy_hour_delete $$
CREATE TRIGGER before_drink_happy_hour_delete
    BEFORE DELETE ON Drink_HappyHour
    FOR EACH ROW
BEGIN
    IF (
           SELECT COUNT(*)
           FROM Drink_HappyHour
           WHERE startAtHappyHour = OLD.startAtHappyHour
       ) = 1 THEN
        CALL send_exception('There needs to be at least one drink per happy hour!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_drink_happy_hour_insert $$
CREATE TRIGGER before_drink_happy_hour_insert
    BEFORE INSERT ON Drink_HappyHour
    FOR EACH ROW
BEGIN
    CALL check_drink_available_during_happy_hour(NEW.startAtHappyHour, NEW.idDrink);
END $$

DROP TRIGGER IF EXISTS before_drink_happy_hour_update $$
CREATE TRIGGER before_drink_happy_hour_update
    BEFORE UPDATE ON Drink_HappyHour
    FOR EACH ROW
BEGIN
    CALL check_drink_available_during_happy_hour(NEW.startAtHappyHour, NEW.idDrink, OLD.startAtHappyHour);
END $$

DROP TRIGGER IF EXISTS before_food_delete $$
CREATE TRIGGER before_food_delete
    BEFORE DELETE ON Food
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Food');
END $$

DROP TRIGGER IF EXISTS before_food_insert $$
CREATE TRIGGER before_food_insert
BEFORE INSERT ON Food
FOR EACH ROW
BEGIN
    CALL check_food_not_drink(NEW.idBuyable);
END $$

DROP TRIGGER IF EXISTS before_food_update $$
CREATE TRIGGER before_food_update
BEFORE UPDATE ON Food
FOR EACH ROW
BEGIN
    CALL check_food_not_drink(NEW.idBuyable);
END $$

DROP TRIGGER IF EXISTS before_food_ingredient_delete $$
CREATE TRIGGER before_food_ingredient_delete
    BEFORE DELETE ON Food_Ingredient
    FOR EACH ROW
BEGIN
    IF (
           SELECT COUNT(*)
           FROM Food_Ingredient
           WHERE idFood = OLD.idFood
       ) = 1 THEN
        CALL send_exception('There needs to be at least one Ingredient per composed food!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_food_ingredient_insert $$
CREATE TRIGGER before_food_ingredient_insert
    BEFORE INSERT ON Food_Ingredient
    FOR EACH ROW
BEGIN
    CALL check_quantity_not_zero(NEW.quantity);

    CALL check_not_composed_food(NEW.idFood);
END $$

DROP TRIGGER IF EXISTS before_food_ingredient_update $$
CREATE TRIGGER before_food_ingredient_update
    BEFORE UPDATE ON Food_Ingredient
    FOR EACH ROW
BEGIN
    CALL check_quantity_not_zero(NEW.quantity);
    CALL check_not_composed_food(NEW.idFood);
END $$

DROP TRIGGER IF EXISTS before_happy_hour_insert $$
CREATE TRIGGER before_happy_hour_insert
    BEFORE INSERT ON HappyHour
    FOR EACH ROW
BEGIN
    CALL check_staff_is_active(new.idManager);
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration, NEW.startAt);
    CALL validate_happy_hour_reduction(NEW.reductionPercent);
END $$

DROP TRIGGER IF EXISTS before_happy_hour_update $$
CREATE TRIGGER before_happy_hour_update
    BEFORE UPDATE ON HappyHour
    FOR EACH ROW
BEGIN
    CALL check_staff_is_active(NEW.idManager);
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration, OLD.startAt);
    CALL validate_happy_hour_reduction(NEW.reductionPercent);
END $$

DROP TRIGGER IF EXISTS before_ingredient_delete $$
CREATE TRIGGER before_ingredient_delete
    BEFORE DELETE ON Ingredient
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Ingredient');
END $$

DROP TRIGGER IF EXISTS before_ingredient_insert $$
CREATE TRIGGER before_ingredient_insert
BEFORE INSERT
ON Ingredient
FOR EACH ROW
BEGIN
    CALL check_ingredient_not_buyable(NEW.idProduct);
END $$

DROP TRIGGER IF EXISTS before_ingredient_update $$
CREATE TRIGGER before_ingredient_update
BEFORE UPDATE
ON Ingredient
FOR EACH ROW
BEGIN
    CALL check_ingredient_not_buyable(NEW.idProduct);
END $$

DROP TRIGGER IF EXISTS before_manager_delete $$
CREATE TRIGGER before_manager_delete
BEFORE DELETE ON Manager
FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Manager');
END $$

DROP TRIGGER IF EXISTS before_manager_update $$
CREATE TRIGGER before_manager_update
BEFORE UPDATE ON Manager
FOR EACH ROW
BEGIN
    DECLARE current_nb_managers INT;

    IF NEW.active = 0 THEN
        SET current_nb_managers = (SELECT COUNT(*) FROM Manager WHERE active = 1);

        -- If there is only one manager in the DB, then he or she can't be deleted
        IF current_nb_managers = 1 THEN
            CALL send_exception('There needs to be at least one manager!');
        END IF;
    END IF;
END $$

DROP TRIGGER IF EXISTS before_product_delete $$
CREATE TRIGGER before_product_delete
    BEFORE DELETE ON Product
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Product');
END $$

DROP TRIGGER IF EXISTS before_product_supply_order_delete $$
CREATE TRIGGER before_product_supply_order_delete
    BEFORE DELETE ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    IF (
        SELECT COUNT(*)
        FROM Product_SupplyOrder
        WHERE idSupplyOrder = OLD.idSupplyOrder
    ) = 1 THEN
        CALL send_exception('There needs to be at least one product per supply order!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_product_supply_order_insert $$
CREATE TRIGGER before_product_supply_order_insert
    BEFORE INSERT ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    CALL check_quantity_not_zero(NEW.quantity);

    IF (
        SELECT id
        FROM vStockableProduct
        WHERE id = NEW.idProduct
    ) IS NULL THEN
        CALL send_exception('Cannot order a product composed with ingredients');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_product_supply_order_update $$
CREATE TRIGGER before_product_supply_order_update
    BEFORE UPDATE ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    CALL send_exception('UPDATE query not allowed on Product_SupplyOrder');
END $$

DROP TRIGGER IF EXISTS before_staff_delete $$
CREATE TRIGGER before_staff_delete
    BEFORE DELETE ON Staff
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Staff');
END $$

DROP TRIGGER IF EXISTS before_stock_delete $$
CREATE TRIGGER before_stock_delete
    BEFORE DELETE ON Stock
    FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on Stock');
END $$

DROP TRIGGER IF EXISTS before_stock_insert $$
CREATE TRIGGER before_stock_insert
    BEFORE INSERT ON Stock
    FOR EACH ROW
BEGIN
    CALL check_product_not_composed(NEW.idProduct);
END $$

DROP TRIGGER IF EXISTS before_stock_update $$
CREATE TRIGGER before_stock_update
    BEFORE UPDATE ON Stock
    FOR EACH ROW
BEGIN
    CALL check_product_not_composed(NEW.idProduct);
END $$

DROP TRIGGER IF EXISTS before_supply_order_insert $$
CREATE TRIGGER before_supply_order_insert
    BEFORE INSERT ON SupplyOrder
    FOR EACH ROW
BEGIN
    CALL check_supply_order_not_customer_order(NEW.idOrder);
    CALL check_staff_is_active(NEW.idManager);
END $$

DROP TRIGGER IF EXISTS before_supply_order_update $$
CREATE TRIGGER before_supply_order_update
    BEFORE UPDATE ON SupplyOrder
    FOR EACH ROW
BEGIN
    CALL check_supply_order_not_customer_order(NEW.idOrder);
    CALL check_staff_is_active(NEW.idManager);
END $$

DROP TRIGGER IF EXISTS before_waiter_delete $$
CREATE TRIGGER before_waiter_delete
BEFORE DELETE ON Waiter
FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on waiter');
END $$

DELIMITER ;USE PUBify;

-- STAFF
INSERT INTO Staff (email, name, lastname, password)
VALUES ('manager@pubify.lo', 'Daenerys', 'Targaryen', '1234'),
       ('waiter@pubify.lo', 'John', 'Snow', '1234'),
       ('manger.disabled@pubify.lo', 'Thomas', 'Shelby', '1234'),
       ('waiter.disabled@pubify.lo', 'John', 'Doe', '1234');

INSERT INTO Waiter (idStaff, active)
VALUES (2, 1),
       (4, 0);

INSERT INTO Manager (idStaff, active)
VALUES (1, 1),
       (3, 0);

-- SUPPLIER
INSERT INTO Supplier (name)
VALUES ('Migros');

-- PRODUCT
INSERT INTO UnitMetric (name, shortname)
VALUES ('Gramme', 'g'),
       ('Litre', 'l'),
       ('Bouteille', 'bt'),
       ('Canette', 'can'),
       ('Piece', 'pc');

INSERT INTO Product (name, nameUnitMetric)
VALUES ('Burger classic', 'Gramme'),
       ('Fish \'N\' Chips', 'Gramme'),
       ('Dr. Gabs', 'Bouteille'),
       ('Farmer', 'Canette'),
       ('Ginger Ale', 'Bouteille'),
       ('Cuvee des Trolls', 'Bouteille'),
       ('Boeuf hache', 'Gramme'),
       ('Pains burger', 'Gramme'),
       ('Cheddar', 'Gramme'),
       ('Salade', 'Gramme'),
       ('Oignon', 'Gramme'),
       ('Tomate', 'Gramme'),
       ('Filet de morue', 'Gramme'),
       ('Frites', 'Gramme'),
       ('Fuse tea', 'Bouteille'),
       ('Biere de noel', 'Bouteille'),
       ('Guiness', 'Bouteille'),
       ('Rosti', 'Piece');

INSERT INTO Stock (idProduct, quantity)
VALUES (3, 50),
       (4, 50),
       (5, 20),
       (6, 50),
       (7, 10000),
       (8, 2500),
       (9, 750),
       (10, 500),
       (11, 250),
       (12, 250),
       (13, 3750),
       (14, 5625),
       (15, 20),
       (16, 15),
       (17, 40),
       (18, 10);

INSERT INTO Buyable (idProduct, price, startSaleDate, endSaleDate)
VALUES (1, 18.50, '2019-01-15 10:00', NULL),
       (2, 23.50, '2019-01-15 12:00', NULL),
       (3, 4.00, '2019-01-15 09:00', NULL),
       (4, 1.00, '2019-01-15 09:00', NULL),
       (5, 2.00, '2019-01-15 09:00', NULL),
       (6, 2.50, '2019-07-01 15:00', NULL),
       (15, 3.50, '2020-01-27 22:00', NULL),
       (16, 4.00, '2019-01-12', '2019-12-30'),
       (17, 3.00, '2019-03-17', NULL),
       (18, 5.00, '2020-01-18 14:23', NULL);

INSERT INTO Ingredient (idProduct)
VALUES (7),
       (8),
       (9),
       (10),
       (11),
       (12),
       (13),
       (14);

INSERT INTO Drink (idBuyable, alcoholLevel)
VALUES (3, 5),
       (4, 5),
       (5, 0),
       (6, 5),
       (15, 0),
       (16, 17),
       (17, 4.2);

INSERT INTO Food
VALUES (1),
       (2),
       (18);

INSERT INTO Food_Ingredient (idFood, idIngredient, quantity)
VALUES (1, 7, 200),
       (1, 8, 100),
       (1, 9, 15),
       (1, 10, 10),
       (1, 11, 5),
       (1, 12, 5),
       (1, 14, 75),
       (2, 13, 150),
       (2, 14, 75);

INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent)
VALUES ('2019-12-24 18:00', 1, '01:00', 15),
       ('2020-01-01 00:00', 1, '02:00', 50),
       ('2020-03-17 17:00', 1, '03:00', 75);

INSERT INTO Drink_HappyHour (idDrink, startAtHappyHour)
VALUES (3, '2019-12-24 18:00'),
       (4, '2019-12-24 18:00'),
       (16, '2019-12-24 18:00'),
       (3, '2020-01-01 00:00'),
       (4, '2020-01-01 00:00'),
       (5, '2020-01-01 00:00'),
       (6, '2020-01-01 00:00'),
       (3, '2020-03-17 17:00'),
       (4, '2020-03-17 17:00'),
       (5, '2020-03-17 17:00'),
       (6, '2020-03-17 17:00'),
       (15, '2020-03-17 17:00'),
       (17, '2020-03-17 17:00');

-- ORDERS
INSERT INTO `Order` (orderAt, tva)
VALUES ('2019-02-01 09:22', 7.7),
       ('2019-05-01 10:11', 7.7),
       ('2019-12-04 17:00', 7.7),
       ('2019-12-22 20:35', 7.7),
       ('2020-01-01 00:15', 7.7),
       ('2020-03-17 18:00', 7.7);

INSERT INTO SupplyOrder (idOrder, idSupplier, idManager)
VALUES (1, 1, 1),
       (2, 1, 1);

INSERT INTO CustomerOrder (idOrder, idWaiter, tableNB)
VALUES (3, 2, 13),
       (4, 2, 25),
       (5, 2, 12),
       (6, 2, 10);

INSERT INTO Product_SupplyOrder (idProduct, idSupplyOrder, price, quantity)
VALUES (3, 1, 4, 20),
       (4, 1, 1, 10),
       (15, 1, 1, 25),
       (9, 2, 5, 300),
       (14, 2, 2, 375),
       (13, 2, 15, 50);

INSERT INTO Buyable_CustomerOrder (idBuyable, idCustomerOrder, price, quantity)
VALUES (1, 3, 18.50, 7),
       (6, 3, 2, 7),
       (2, 4, 23.5, 1),
       (1, 4, 18.5, 1),
       (16, 4, 2, 2),
       (4, 5, 2, 15),
       (3, 6, 4, 3),
       (6, 6, 2, 3),
       (17, 6, 4, 5);
