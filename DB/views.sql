DROP VIEW IF EXISTS waiters;
CREATE VIEW waiters
AS
    SELECT
        Staff.id,
        Staff.name,
        Staff.lastname,
        Staff.email
    FROM Waiter
        INNER JOIN Staff
            ON Staff.id = Waiter.idStaff;

DROP VIEW IF EXISTS managers;
CREATE VIEW managers
AS
    SELECT
        Staff.id,
        Staff.name,
        Staff.lastname,
        Staff.email
    FROM Manager
        INNER JOIN Staff
            ON Staff.id = Manager.idStaff;

DROP VIEW IF EXISTS customer_orders;
CREATE VIEW customer_orders
AS
    SELECT
        `Order`.id,
        `Order`.orderAt,
        CustomerOrder.tableNB,
        waiters.name,
        waiters.lastname,
        `Order`.tva
    FROM CustomerOrder
        INNER JOIN `Order`
            ON `Order`.id = CustomerOrder.idOrder
        INNER JOIN waiters
            ON waiters.id = CustomerOrder.idWaiter;

DROP VIEW IF EXISTS supply_orders;
CREATE VIEW supply_orders
AS
    SELECT
        `Order`.id,
        `Order`.orderAt,
        managers.name AS manager_name,
        managers.lastname AS manager_lastname,
        Supplier.name AS supplier_name,
        `Order`.tva
    FROM SupplyOrder
        INNER JOIN `Order`
            ON `Order`.id = SupplyOrder.idOrder
        INNER JOIN managers
            ON managers.id = SupplyOrder.idManager
        INNER JOIN Supplier
            ON SupplyOrder.idSupplier = Supplier.id;

DROP VIEW IF EXISTS products;
CREATE VIEW products
AS
    SELECT
        Product.id,
        Product.name AS product_name,
        UnitMetric.name AS unit_name,
        UnitMetric.shortName AS unit_shortName
    FROM Product
        INNER JOIN UnitMetric
            ON Product.nameUnitMetric = UnitMetric.name;

DROP VIEW IF EXISTS products_with_stock;
CREATE VIEW products_with_stock
AS
    SELECT
        products.*,
        Stock.quantity
    FROM products
        RIGHT JOIN Stock
            ON products.id = Stock.idProduct;

DROP VIEW IF EXISTS buyables;
CREATE VIEW buyables
AS
    SELECT
        products.*,
        Buyable.price,
        Buyable.startSaleDate,
        Buyable.endSaleDate
    FROM Buyable
        INNER JOIN products
            ON products.id = Buyable.idProduct;

DROP VIEW IF EXISTS buyable_with_stock;
CREATE VIEW buyable_with_stock
AS
    SELECT
        buyables.*,
        Stock.quantity
    FROM buyables
        RIGHT JOIN Stock
            ON buyables.id = Stock.idProduct;

DROP VIEW IF EXISTS drinks;
CREATE VIEW drinks
AS
    SELECT
        buyable_with_stock.*,
        Drink.alcoholLevel
    FROM Drink
        INNER JOIN buyable_with_stock
            ON Drink.idBuyable = buyable_with_stock.id;

DROP VIEW IF EXISTS foods;
CREATE VIEW foods
AS
    SELECT
        buyables.*
    FROM Food
        INNER JOIN buyables
            ON Food.idBuyable = buyables.id;

DROP VIEW IF EXISTS food_with_stock;
CREATE VIEW food_with_stock
AS
    SELECT
        buyable_with_stock.*
    FROM Food
        INNER JOIN buyable_with_stock
            ON Food.idBuyable = buyable_with_stock.id;

DROP VIEW IF EXISTS food_without_stock;
CREATE VIEW food_without_stock
AS
    SELECT
        foods.*
    FROM foods
        LEFT JOIN Stock
            ON foods.id = Stock.idProduct
    WHERE Stock.id IS NULL;

DROP VIEW IF EXISTS ingredients;
CREATE VIEW ingredients
AS
    SELECT
        products_with_stock.*
    FROM Ingredient
        INNER JOIN products_with_stock
            ON Ingredient.idProduct = products_with_stock.id;