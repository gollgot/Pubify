USE PUBify;

-- STAFF
INSERT INTO Staff (email, name, lastname, password)
VALUES ('manager@pubify.lo', 'Daenerys', 'Targaryen', '1234'),
       ('waiter@pubify.lo', 'John', 'Snow', '1234'),
       ('manger.disabled@pubify.lo', 'Thomas', 'Shelby', '1234'),
       ('waiter.disabled@pubify.lo', 'John', 'Doe', '1234');

INSERT INTO Waiter (idStaff, active)
VALUES (2, 1),
       (4, 0);

INSERT INTO Manager (idStaff, active)
VALUES (1, 1),
       (3, 0);

-- SUPPLIER
INSERT INTO Supplier (name)
VALUES ('Migros'),
	   ('Aligro');

-- PRODUCT
INSERT INTO UnitMetric (name, shortname)
VALUES ('Gramme', 'g'),
       ('Litre', 'l'),
       ('Bouteille', 'bt'),
       ('Canette', 'can'),
       ('Piece', 'pc');

INSERT INTO Product (name, nameUnitMetric)
VALUES ('Burger classic', 'Gramme'),
       ('Fish \'N\' Chips', 'Gramme'),
       ('Dr. Gabs', 'Bouteille'),
       ('Farmer', 'Canette'),
       ('Ginger Ale', 'Bouteille'),
       ('Cuvee des Trolls', 'Bouteille'),
       ('Boeuf hache', 'Gramme'),
       ('Pains burger', 'Gramme'),
       ('Cheddar', 'Gramme'),
       ('Salade', 'Gramme'),
       ('Oignon', 'Gramme'),
       ('Tomate', 'Gramme'),
       ('Filet de morue', 'Gramme'),
       ('Frites', 'Gramme'),
       ('Fuse tea', 'Bouteille'),
       ('Biere de noel', 'Bouteille'),
       ('Guiness', 'Bouteille'),
       ('Rosti', 'Piece');

INSERT INTO Stock (idProduct, quantity)
VALUES (3, 50),
       (4, 50),
       (5, 20),
       (6, 50),
       (7, 10000),
       (8, 2500),
       (9, 750),
       (10, 500),
       (11, 250),
       (12, 250),
       (13, 3750),
       (14, 5625),
       (15, 20),
       (16, 15),
       (17, 40),
       (18, 10);

INSERT INTO Buyable (idProduct, price, startSaleDate, endSaleDate)
VALUES (1, 18.50, '2019-01-15 10:00', NULL),
       (2, 23.50, '2019-01-15 12:00', NULL),
       (3, 4.00, '2019-01-15 09:00', NULL),
       (4, 1.00, '2019-01-15 09:00', NULL),
       (5, 2.00, '2019-01-15 09:00', NULL),
       (6, 2.50, '2019-07-01 15:00', NULL),
       (15, 3.50, '2020-01-27 22:00', NULL),
       (16, 4.00, '2019-01-12', '2019-12-30'),
       (17, 3.00, '2019-03-17', NULL),
       (18, 5.00, '2020-01-18 14:23', NULL);

INSERT INTO Ingredient (idProduct)
VALUES (7),
       (8),
       (9),
       (10),
       (11),
       (12),
       (13),
       (14);

INSERT INTO Drink (idBuyable, alcoholLevel)
VALUES (3, 5),
       (4, 5),
       (5, 0),
       (6, 5),
       (15, 0),
       (16, 17),
       (17, 4.2);

INSERT INTO Food
VALUES (1),
       (2),
       (18);

INSERT INTO Food_Ingredient (idFood, idIngredient, quantity)
VALUES (1, 7, 200),
       (1, 8, 100),
       (1, 9, 15),
       (1, 10, 10),
       (1, 11, 5),
       (1, 12, 5),
       (1, 14, 75),
       (2, 13, 150),
       (2, 14, 75);

INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent)
VALUES ('2019-12-24 18:00', 1, '01:00', 15),
       ('2020-01-01 00:00', 1, '02:00', 50),
       ('2020-03-17 17:00', 1, '03:00', 75);

INSERT INTO Drink_HappyHour (idDrink, startAtHappyHour)
VALUES (3, '2019-12-24 18:00'),
       (4, '2019-12-24 18:00'),
       (16, '2019-12-24 18:00'),
       (3, '2020-01-01 00:00'),
       (4, '2020-01-01 00:00'),
       (5, '2020-01-01 00:00'),
       (6, '2020-01-01 00:00'),
       (3, '2020-03-17 17:00'),
       (4, '2020-03-17 17:00'),
       (5, '2020-03-17 17:00'),
       (6, '2020-03-17 17:00'),
       (15, '2020-03-17 17:00'),
       (17, '2020-03-17 17:00');

-- ORDERS
INSERT INTO `Order` (orderAt, tva)
VALUES ('2019-02-01 09:22', 7.7),
       ('2019-05-01 10:11', 7.7),
       ('2019-12-04 17:00', 7.7),
       ('2019-12-22 20:35', 7.7),
       ('2020-01-01 00:15', 7.7),
       ('2020-01-17 18:00', 7.7);

INSERT INTO SupplyOrder (idOrder, idSupplier, idManager)
VALUES (1, 1, 1),
       (2, 1, 1);

INSERT INTO CustomerOrder (idOrder, idWaiter, tableNB)
VALUES (3, 2, 13),
       (4, 2, 25),
       (5, 2, 12),
       (6, 2, 10);

INSERT INTO Product_SupplyOrder (idProduct, idSupplyOrder, price, quantity)
VALUES (3, 1, 4, 20),
       (4, 1, 1, 10),
       (15, 1, 1, 25),
       (9, 2, 5, 300),
       (14, 2, 2, 375),
       (13, 2, 15, 50);

INSERT INTO Buyable_CustomerOrder (idBuyable, idCustomerOrder, price, quantity)
VALUES (1, 3, 18.50, 7),
       (6, 3, 2, 7),
       (2, 4, 23.5, 1),
       (1, 4, 18.5, 1),
       (16, 4, 2, 2),
       (4, 5, 1, 15),
       (3, 6, 4, 3),
       (6, 6, 2, 3),
       (17, 6, 4, 5);
