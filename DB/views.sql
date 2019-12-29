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

CREATE VIEW product_with_metrics
AS
    SELECT
        Product.id,
        Product.name AS product_name,
        UnitMetric.name AS unit_name,
        UnitMetric.shortName AS unit_shortName,
        Product.idStock
    FROM Product
        INNER JOIN UnitMetric
            ON Product.nameUnitMetric = UnitMetric.name;

CREATE VIEW products_with_stock_and_metrics
AS
    SELECT
        product_with_metrics.id,
        product_with_metrics.product_name,
        product_with_metrics.unit_name,
        product_with_metrics.unit_shortName,
        Stock.quantity
    FROM product_with_metrics
        RIGHT JOIN Stock
            ON product_with_metrics.idStock = Stock.id;

CREATE VIEW products_without_stock_and_metrics
AS
    SELECT
        product_with_metrics.id,
        product_with_metrics.product_name,
        product_with_metrics.unit_name,
        product_with_metrics.unit_shortName
    FROM product_with_metrics
    WHERE product_with_metrics.idStock IS NULL;

CREATE VIEW drinks
AS
    SELECT
        products_with_stock_and_metrics.*,
        Buyable.price,
        Buyable.startSaleDate,
        Buyable.endSaleDate,
        Drink.alcoholLevel
    FROM Drink
        INNER JOIN Buyable
            ON Drink.idBuyable = Buyable.idProduct
        INNER JOIN products_with_stock_and_metrics
            ON Buyable.idProduct = products_with_stock_and_metrics.id;

CREATE VIEW foods
AS
    SELECT
        product_with_metrics.*,
        Buyable.price,
        Buyable.startSaleDate,
        Buyable.endSaleDate
    FROM Food
        INNER JOIN Buyable
            ON Food.idBuyable = Buyable.idProduct
        INNER JOIN product_with_metrics
            ON Buyable.idProduct = product_with_metrics.id;

CREATE VIEW food_with_stock
AS
    SELECT
        products_with_stock_and_metrics.*,
        Buyable.price,
        Buyable.startSaleDate,
        Buyable.endSaleDate
    FROM Food
        INNER JOIN Buyable
            ON Food.idBuyable = Buyable.idProduct
        INNER JOIN products_with_stock_and_metrics
            ON products_with_stock_and_metrics.id = Buyable.idProduct;

CREATE VIEW ingredients
AS
    SELECT
        products_with_stock_and_metrics.*
    FROM Ingredient
        INNER JOIN products_with_stock_and_metrics
            ON Ingredient.idProduct = products_with_stock_and_metrics.id;