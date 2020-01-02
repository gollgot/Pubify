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

DELIMITER ;
