DROP VIEW IF EXISTS waiters;
CREATE VIEW waiters
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email
FROM Waiter
    INNER JOIN Staff
        ON Staff.id = Waiter.idStaff;

DROP VIEW IF EXISTS managers;
CREATE VIEW managers
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email
FROM Manager
    INNER JOIN Staff
        ON Staff.id = Manager.idStaff;

DROP VIEW IF EXISTS customer_orders;
CREATE VIEW customer_orders
AS
SELECT `Order`.id,
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
SELECT `Order`.id,
       `Order`.orderAt,
       managers.name     AS manager_name,
       managers.lastname AS manager_lastname,
       Supplier.name     AS supplier_name,
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
SELECT Product.id,
       Product.name         AS product_name,
       UnitMetric.name      AS unit_name,
       UnitMetric.shortName AS unit_shortName
FROM Product
    INNER JOIN UnitMetric
        ON Product.nameUnitMetric = UnitMetric.name;

DROP VIEW IF EXISTS products_with_stock;
CREATE VIEW products_with_stock
AS
SELECT products.*,
       Stock.quantity
FROM products
    RIGHT JOIN Stock
        ON products.id = Stock.idProduct;

DROP VIEW IF EXISTS buyables;
CREATE VIEW buyables
AS
SELECT products.*,
       Buyable.price,
       Buyable.startSaleDate,
       Buyable.endSaleDate
FROM Buyable
    INNER JOIN products
        ON products.id = Buyable.idProduct;

DROP VIEW IF EXISTS buyable_with_stock;
CREATE VIEW buyable_with_stock
AS
SELECT buyables.*,
       Stock.quantity
FROM buyables
    LEFT JOIN Stock
        ON buyables.id = Stock.idProduct;

DROP VIEW IF EXISTS drinks;
CREATE VIEW drinks
AS
SELECT buyable_with_stock.*,
       Drink.alcoholLevel
FROM Drink
    INNER JOIN buyable_with_stock
        ON Drink.idBuyable = buyable_with_stock.id;

DROP VIEW IF EXISTS foods;
CREATE VIEW foods
AS
SELECT buyables.*
FROM Food
    INNER JOIN buyables
        ON Food.idBuyable = buyables.id;

DROP VIEW IF EXISTS food_with_stock;
CREATE VIEW food_with_stock
AS
SELECT buyable_with_stock.*
FROM Food
    INNER JOIN buyable_with_stock
        ON Food.idBuyable = buyable_with_stock.id;

DROP VIEW IF EXISTS food_without_stock;
CREATE VIEW food_without_stock
AS
SELECT foods.*
FROM foods
    LEFT JOIN Stock
        ON foods.id = Stock.idProduct
WHERE Stock.id IS NULL;

DROP VIEW IF EXISTS ingredients;
CREATE VIEW ingredients
AS
SELECT products_with_stock.*
FROM Ingredient
    INNER JOIN products_with_stock
        ON Ingredient.idProduct = products_with_stock.id;




DROP VIEW IF EXISTS vWaiter;
CREATE VIEW vWaiter
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email
FROM Waiter
    INNER JOIN Staff
        ON Staff.id = Waiter.idStaff;

DROP VIEW IF EXISTS vManager;
CREATE VIEW vManager
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email
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
    LEFT JOIN Stock
        ON vBuyable.id = Stock.idProduct;

DROP VIEW IF EXISTS vDrink;
CREATE VIEW vDrink
AS
SELECT vStockableBuyable.*,
       Drink.alcoholLevel
FROM Drink
    INNER JOIN vStockableBuyable
        ON Drink.idBuyable = vStockableBuyable.id;

DROP VIEW IF EXISTS vFood;
CREATE VIEW vFood
AS
SELECT vBuyable.*
FROM Food
    INNER JOIN vBuyable
        ON Food.idBuyable = vBuyable.id;

DROP VIEW IF EXISTS vStockableFood;
CREATE VIEW vStockableFood
AS
SELECT vStockableBuyable.*
FROM Food
    INNER JOIN vStockableBuyable
        ON Food.idBuyable = vStockableBuyable.id;

DROP VIEW IF EXISTS vUnstockableFood;
CREATE VIEW vUnstockableFood
AS
SELECT vFood.*
FROM vFood
    LEFT JOIN Stock
        ON vFood.id = Stock.idProduct
WHERE Stock.id IS NULL;

DROP VIEW IF EXISTS vIngredient;
CREATE VIEW vIngredient
AS
SELECT vStockableProduct.*
FROM vStockableProduct
    INNER JOIN Ingredient
        ON Ingredient.idProduct = vStockableProduct.id;