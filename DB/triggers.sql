USE PUBify;

DELIMITER $$
-- -----------------------------------------------
-- AFTER Triggers
-- -----------------------------------------------
DROP TRIGGER IF EXISTS after_buyable_customer_order_delete $$
CREATE TRIGGER after_buyable_customer_order_delete
    AFTER DELETE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    -- todo: Add stock
END $$

DROP TRIGGER IF EXISTS after_buyable_customer_order_insert $$
CREATE TRIGGER after_buyable_customer_order_insert
    AFTER INSERT ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    -- todo: Sub stock
END $$

DROP TRIGGER IF EXISTS after_buyable_customer_order_update $$
CREATE TRIGGER after_buyable_customer_order_update
    AFTER UPDATE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    -- todo: Adapt stock +/-
END $$

DROP TRIGGER IF EXISTS after_customer_order_delete $$
CREATE TRIGGER after_customer_order_delete
    AFTER DELETE ON CustomerOrder
    FOR EACH ROW
BEGIN
    -- todo: delete the linked order
END $$

DROP TRIGGER IF EXISTS after_product_supply_order_delete $$
CREATE TRIGGER after_product_supply_order_delete
    AFTER DELETE ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    -- todo: Sub stock
END $$

DROP TRIGGER IF EXISTS after_product_supply_order_insert $$
CREATE TRIGGER after_product_supply_order_insert
    AFTER INSERT ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    -- todo: Add stock
END $$

DROP TRIGGER IF EXISTS after_product_supply_order_update $$
CREATE TRIGGER after_product_supply_order_update
    AFTER UPDATE ON Product_SupplyOrder
    FOR EACH ROW
BEGIN
    -- todo: Adapt stock +/-
END $$

DROP TRIGGER IF EXISTS after_supply_order_delete $$
CREATE TRIGGER after_supply_order_delete
    AFTER DELETE ON SupplyOrder
    FOR EACH ROW
BEGIN
    -- todo: delete the linked order
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
        CALL send_exception('There needs to be at least one product by customer order!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_buyable_customer_order_insert $$
CREATE TRIGGER before_buyable_customer_order_insert
    BEFORE INSERT ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    DECLARE stock_id INT;
    DECLARE error BOOLEAN;

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

    CALL check_quantity_not_zero(NEW.quantity);

    SET stock_id = (
        SELECT id
        FROM Stock
        WHERE idProduct = NEW.idBuyable
    );
    SET error = false;

    IF stock_id IS NULL THEN
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

    -- TODO: déplacer dans le after insert
    -- All good regarding the quantity, so we can deduct it from the stock
    IF stock_id IS NOT NULL THEN
        UPDATE Stock
        SET Stock.quantity = (Stock.quantity - NEW.quantity)
        WHERE idProduct = NEW.idBuyable;
    ELSE
        OPEN cur_ingredient;

        updateIngredientStock: LOOP
            FETCH cur_ingredient INTO ingredient_id;
            IF finished = 1 THEN
                LEAVE updateIngredientStock;
            END IF;

            SET used_quantity = (
                SELECT quantity
                FROM Food_Ingredient
                WHERE idFood = NEW.idBuyable AND
                        idIngredient = ingredient_id
            );

            UPDATE Stock
            SET Stock.quantity = (Stock.quantity - used_quantity*NEW.quantity)
            WHERE idProduct = ingredient_id;
        END LOOP;

        CLOSE cur_ingredient;
    END IF;
END $$

DROP TRIGGER IF EXISTS before_buyable_customer_order_update $$
CREATE TRIGGER before_buyable_customer_order_update
    BEFORE UPDATE ON Buyable_CustomerOrder
    FOR EACH ROW
BEGIN
    CALL check_quantity_not_zero(NEW.quantity);
END $$

DROP TRIGGER IF EXISTS before_customer_order_insert $$
CREATE TRIGGER before_customer_order_insert
    BEFORE INSERT ON CustomerOrder
    FOR EACH ROW
BEGIN
    CALL check_customer_order_not_supply_order(NEW.idOrder);

    IF (
           SELECT active
           FROM Waiter
           WHERE idStaff = NEW.idWaiter
       ) = 0 THEN
        CALL send_exception('A deleted waiter cannot take an order');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_customer_order_update $$
CREATE TRIGGER before_customer_order_update
    BEFORE UPDATE ON CustomerOrder
    FOR EACH ROW
BEGIN
    CALL check_customer_order_not_supply_order(NEW.idOrder);

    IF (
           SELECT active
           FROM Waiter
           WHERE idStaff = NEW.idWaiter
       ) = 0 THEN
        CALL send_exception('A deleted waiter cannot take an order');
    END IF;
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
        CALL send_exception('There needs to be at least one drink by happy hour!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_drink_happy_hour_insert $$
CREATE TRIGGER before_drink_happy_hour_insert
    BEFORE INSERT ON Drink_HappyHour
    FOR EACH ROW
BEGIN
    CALL check_drink_sale_date_within_happy_hour_duration(NEW.startAtHappyHour, NEW.idDrink);
END $$

DROP TRIGGER IF EXISTS before_drink_happy_hour_update $$
CREATE TRIGGER before_drink_happy_hour_update
    BEFORE UPDATE ON Drink_HappyHour
    FOR EACH ROW
BEGIN
    CALL check_drink_sale_date_within_happy_hour_duration(NEW.startAtHappyHour, NEW.idDrink);
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
        CALL send_exception('There needs to be at least one Ingredient by composed food!');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_food_ingredient_insert $$
CREATE TRIGGER before_food_ingredient_insert
    BEFORE INSERT ON Food_Ingredient
    FOR EACH ROW
BEGIN
    DECLARE food_stock_quantity INT;

    CALL check_quantity_not_zero(NEW.quantity);

    SET food_stock_quantity = (
        SELECT quantity
        FROM Stock
        WHERE idProduct = NEW.idFood
    );

    IF food_stock_quantity > 0 THEN
        CALL send_exception('A stockable Food can\'t have Ingredients');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_food_ingredient_update $$
CREATE TRIGGER before_food_ingredient_update
    BEFORE UPDATE ON Food_Ingredient
    FOR EACH ROW
BEGIN
    DECLARE food_stock_quantity INT;

    CALL check_quantity_not_zero(NEW.quantity);

    SET food_stock_quantity = (
        SELECT quantity
        FROM Stock
        WHERE idProduct = NEW.idFood
    );

    IF food_stock_quantity > 0 THEN
        CALL send_exception('A stockable Food can\'t have Ingredients');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_happy_hour_insert $$
CREATE TRIGGER before_happy_hour_insert
    BEFORE INSERT ON HappyHour
    FOR EACH ROW
BEGIN
    /* todo: check if manager is active */
    /* y a-t-il vraiment besoin de faire un procédure pour un if New.duration <= 0 ? */
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration);
    /* y a-t-il vraiment besoin de faire un procédure pour un if New.reductionPercent <= 0 ? */
    CALL validate_happy_hour_reduction(NEW.reductionPercent);
END $$

DROP TRIGGER IF EXISTS before_happy_hour_update $$
CREATE TRIGGER before_happy_hour_update
    BEFORE UPDATE ON HappyHour
    FOR EACH ROW
BEGIN
    /* todo: check if manager is active */
    /* y a-t-il vraiment besoin de faire un procédure pour un if New.duration <= 0 ? */
    CALL validate_happy_hour_duration(NEW.duration);
    CALL check_happy_hour_not_overlapping(NEW.startAt, NEW.duration);
    /* y a-t-il vraiment besoin de faire un procédure pour un if New.reductionPercent <= 0 ? */
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
        SET current_nb_managers = (SELECT COUNT(*) FROM Manager);

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
        CALL send_exception('There needs to be at least one product by supply order!');
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
    CALL check_quantity_not_zero(NEW.quantity);

    IF (
        SELECT id
        FROM vStockableProduct
        WHERE id = NEW.idProduct
    ) IS NULL THEN
        CALL send_exception('Cannot order a product composed with ingredients');
    END IF;
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

    IF (
           SELECT active
           FROM Manager
           WHERE idStaff = NEW.idManager
       ) = 0 THEN
        CALL send_exception('A deleted manager cannot take an order');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_supply_order_update $$
CREATE TRIGGER before_supply_order_update
    BEFORE UPDATE ON SupplyOrder
    FOR EACH ROW
BEGIN
    CALL check_supply_order_not_customer_order(NEW.idOrder);

    IF (
           SELECT active
           FROM Manager
           WHERE idStaff = NEW.idManager
       ) = 0 THEN
        CALL send_exception('A deleted manager cannot take an order');
    END IF;
END $$

DROP TRIGGER IF EXISTS before_waiter_delete $$
CREATE TRIGGER before_waiter_delete
BEFORE DELETE ON Waiter
FOR EACH ROW
BEGIN
    CALL send_exception('DELETE query not allowed on waiter');
END $$

DELIMITER ;