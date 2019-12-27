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


DELIMITER ;