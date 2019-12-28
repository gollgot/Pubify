USE PUBify;

DELIMITER $$

CREATE TRIGGER before_drink_insert
BEFORE INSERT ON Drink
FOR EACH ROW
BEGIN
    IF is_negative_decimal(NEW.alcoholLevel) THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alcohol level can\'t be negative!';
    END IF;
END $$

CREATE TRIGGER before_happy_hour_insert
BEFORE INSERT ON HappyHour
FOR EACH ROW
BEGIN
    DECLARE max_reduction_percent INT;
    SET max_reduction_percent = 100;

    IF is_negative_decimal(NEW.reductionPercent) AND NEW.reductionPercent <= max_reduction_percent THEN
        -- return an `unhandeled used-defined exception`
        -- see : https://dev.mysql.com/doc/refman/5.5/en/signal.html
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '`reductionPercent` must be greater then 0 and lower than 100';
    END IF;
END $$

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

DELIMITER ;