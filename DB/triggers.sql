USE PUBify;

DELIMITER $$

DROP TRIGGER IF EXISTS before_drink_insert $$
CREATE TRIGGER before_drink_insert
BEFORE INSERT ON Drink
FOR EACH ROW
BEGIN
    CALL validate_alcohol_level(NEW.alcoholLevel);
END $$

DROP TRIGGER IF EXISTS before_drink_update $$
CREATE TRIGGER before_drink_update
BEFORE UPDATE ON Drink
FOR EACH ROW
BEGIN
    CALL validate_alcohol_level(NEW.alcoholLevel);
END $$

DROP TRIGGER IF EXISTS before_happy_hour_insert $$
CREATE TRIGGER before_happy_hour_insert
BEFORE INSERT ON HappyHour
FOR EACH ROW
BEGIN
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration);
    CALL validate_happy_hour_reduction(NEW.reductionPercent);
END $$

DROP TRIGGER IF EXISTS before_happy_hour_update $$
CREATE TRIGGER before_happy_hour_update
BEFORE UPDATE ON HappyHour
FOR EACH ROW
BEGIN
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration);
    CALL validate_happy_hour_reduction(NEW.reductionPercent);
END $$

DROP TRIGGER IF EXISTS before_manager_delete $$
CREATE TRIGGER before_manager_delete
BEFORE DELETE ON Manager
FOR EACH ROW
BEGIN
    DECLARE current_nb_managers INT;

    SET current_nb_managers = (SELECT COUNT(*) FROM Manager);

    -- If there is only one manager in the DB, then he or she can't be deleted
    IF current_nb_managers = 1 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There needs to be more than one manager to delete one!';
    END IF;
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

-- TODO: voir comment faire pour le before update (décision à prendre)
/*
DROP TRIGGER IF EXISTS before_buyable_customer_order_insert
CREATE TRIGGER before_buyable_customer_order_insert
BEFORE INSERT ON Buyable_CustomerOrder
FOR EACH ROW
BEGIN
    DECLARE stock_id INT;
    DECLARE error BOOLEAN;

    SET stock_id = (
        SELECT idStock
        FROM Product
        WHERE id = NEW.idBuyable
    );
    SET error = false;

    IF stock_id IS NULL THEN
        IF (
            SELECT COUNT(*)
            FROM Food_Ingredient
                INNER JOIN Product
                    ON Food_Ingredient.idIngredient = Product.id
                INNER JOIN Stock
                    ON Product.idStock = Stock.id
            WHERE idFood = NEW.idBuyable
            AND Stock.quantity < Food_Ingredient.quantity * NEW.quantity
        ) THEN
            SET error = true;
        END IF;
    ELSE
        IF (SELECT quantity FROM Stock WHERE id = stock_id) < NEW.quantity THEN
            SET error = true;
        END IF;
    END IF;

    IF error = true THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock for the order';
    END IF;
END
*/

DELIMITER ;