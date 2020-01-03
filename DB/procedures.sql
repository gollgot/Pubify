USE PUBify;

DELIMITER $$

-- ------------------------------------ --
-- GENERAL USAGE PROCEDURES n FUNCTIONS --
-- ------------------------------------ --

DROP FUNCTION IF EXISTS is_negative_int $$
CREATE FUNCTION is_negative_int(num INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN IF(num < 0, TRUE, FALSE);
END $$

DROP FUNCTION IF EXISTS is_negative_time $$
CREATE FUNCTION is_negative_time(`time` TIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN IF(`time` < 0, TRUE, FALSE);
END $$

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
    RETURN IF(value BETWEEN min AND max, TRUE, FALSE);
END $$

-- ------------------------------- --
-- SPECIFIC PROCEDURES n FUNCTIONS --
-- ------------------------------- --

/* DRINK */
DROP PROCEDURE IF EXISTS validate_alcohol_level $$
CREATE PROCEDURE validate_alcohol_level(alcohol_level DECIMAL)
BEGIN
    IF NOT within_range_decimal(0, 100, alcohol_level) THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alcohol level can\'t be negative!';
    END IF;
END $$

/* HAPPY HOUR */
DROP PROCEDURE IF EXISTS validate_happy_hour_reduction $$
CREATE PROCEDURE validate_happy_hour_reduction(reduction INT)
BEGIN
    DECLARE max_reduction_percent INT;
    DECLARE min_reduction_percent INT;
    SET max_reduction_percent = 100;
    SET min_reduction_percent = 0;

    IF NOT within_range_int(0, 100, reduction) THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The reduction percent must be within 0 and 100';
    END IF;
END $$

DROP PROCEDURE IF EXISTS validate_happy_hour_duration $$
CREATE PROCEDURE validate_happy_hour_duration(duration TIME)
BEGIN
    IF is_negative_time(duration) THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The duration of a Happy Hour can\'t be negative!';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_happy_hour_not_overlapping $$
CREATE PROCEDURE check_happy_hour_not_overlapping(new_startAt DATETIME, new_duration TIME)
BEGIN
    DECLARE nb_overlapping INT;
    SET nb_overlapping = (
        SELECT COUNT(*) FROM HappyHour
        WHERE new_startAt BETWEEN startAt AND ADDTIME(startAt, duration) OR
              startAt BETWEEN new_startAt AND ADDTIME(new_startAt, new_duration));

    IF nb_overlapping > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Happy hours can\'t be overlapping';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_product_not_composed $$
CREATE PROCEDURE check_product_not_composed(idProduct INT)
BEGIN
    IF (SELECT COUNT(*) FROM Food_Ingredient WHERE idFood = idProduct) > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Composed products can\'t be stocked!';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_quantity_not_zero $$
CREATE PROCEDURE check_quantity_not_zero(quantity INT)
BEGIN
    IF quantity <= 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The quantity can\'t be 0 or lower';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_start_sale_before_end_sale $$
CREATE PROCEDURE check_start_sale_before_end_sale(`start` DATETIME, `end` DATETIME)
BEGIN
    IF `start` > `end` THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Starting sale date can\'t be greater than the ending date';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_drink_sale_date_within_happy_hour_duration $$
CREATE PROCEDURE check_drink_sale_date_within_happy_hour_duration(startAtHappyHour DATETIME, idDrink INT)
BEGIN
    DECLARE end_drink_sale DATETIME;
    DECLARE happy_hour_duration TIME;

    SET end_drink_sale = (
        SELECT endSaleDate
        FROM Buyable
        WHERE idProduct = idDrink
    );

    SET happy_hour_duration = (
        SELECT duration
        FROM HappyHour
        WHERE startAt = startAtHappyHour
    );

    if NOT within_range_datetime(startAtHappyHour, ADDTIME(startAtHappyHour, happy_hour_duration), end_drink_sale) THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chosen drink can\'t be sold during the whole happy hour';
    END IF;

END $$

DROP PROCEDURE IF EXISTS check_buyable_not_ingredient $$
CREATE PROCEDURE check_buyable_not_ingredient(idBuyable INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Ingredient
        WHERE Ingredient.idProduct = idBuyable
    ) > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An Ingredient can\'t be a Buyable';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_ingredient_not_buyable $$
CREATE PROCEDURE check_ingredient_not_buyable(idIngredient INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Buyable
        WHERE Buyable.idProduct = idIngredient
    ) > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A Buyable can\'t be an Ingredient';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_drink_not_food $$
CREATE PROCEDURE check_drink_not_food(idDrink INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Food
        WHERE Food.idBuyable = idDrink
    ) > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A Food can\'t be a Drink';
    END IF;
END $$

DROP PROCEDURE IF EXISTS check_food_not_drink $$
CREATE PROCEDURE check_food_not_drink(idFood INT)
BEGIN
    IF (SELECT COUNT(*)
        FROM Drink
        WHERE Drink.idBuyable = idFood
    ) > 0 THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A Drink can\'t be a Food';
    END IF;
END $$

DELIMITER ;
