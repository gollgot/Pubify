DROP VIEW IF EXISTS vActiveStaff;
CREATE VIEW vActiveStaff
AS
SELECT Staff.id,
       Staff.email,
       Staff.name,
       Staff.lastname,
       Staff.password
FROM Staff 
    INNER JOIN Waiter
        ON Staff.id = Waiter.idStaff
WHERE active = 1
UNION
SELECT Staff.id,
       Staff.email,
       Staff.name,
       Staff.lastname,
       Staff.password
FROM Staff
    INNER JOIN Manager
        ON Staff.id = Manager.idStaff
WHERE active = 1;

DROP VIEW IF EXISTS vWaiter;
CREATE VIEW vWaiter
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email,
       Waiter.active
FROM Waiter
    INNER JOIN Staff
        ON Staff.id = Waiter.idStaff;

DROP VIEW IF EXISTS vManager;
CREATE VIEW vManager
AS
SELECT Staff.id,
       Staff.name,
       Staff.lastname,
       Staff.email,
       Manager.active
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
    INNER JOIN Stock
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

DROP VIEW IF EXISTS vNonstockableFood;
CREATE VIEW vNonstockableFood
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