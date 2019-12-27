USE PUBify;

DELIMITER $$

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
END
$$

DELIMITER ;