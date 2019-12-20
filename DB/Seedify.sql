USE PUBify;

-- Staff
INSERT INTO Staff (email, name, lastname, password)
VALUES ('john.snow@pubify.com', 'John', 'Snow', '.Etml-1'),
       ('daenerys.targaryen@pubify.com', 'Daenerys', 'Targaryen', '.Etml-1'),
       ('obiwan.kenobi@pubify.com', 'Obi Wan', 'Kenobi', '.Etml-1'),
       ('darth.vader@pubify.com', 'Darth', 'Vader', '.Etml-1');

INSERT INTO Waiter (idStaff)
VALUES (1),
       (3),
       (4);

INSERT INTO Manager (idStaff)
VALUES (2);

INSERT INTO Supplier (name)
VALUES ('Aligro'),
       ('Dr. Gabs');

-- Product
INSERT INTO UnitMetric (name, shortname)
VALUES ('Gram', 'g'),
       ('Litre', 'l'),
       ('Bottle', 'bt'),
       ('Can', 'can');

INSERT INTO Stock (quantity)
VALUES (22),
       (4),
       (16),
       (2),
       (2000),
       (10),
       (200),
       (2000),
       (500),
       (500),
       (2000),
       (4000);

INSERT INTO Product (name, idStock, nameUnitMetric)
VALUES ('Classic Beef Burger', NULL, 'Gram'),
       ('Fish \'N\' Chips', NULL, 'Gram'),
       ('Dr. Gabs', 1, 'Bottle'),
       ('Farmer', 2, 'Can'),
       ('Ginger Ale', 3, 'Bottle'),
       ('Cuvée des Trolls', 4, 'Bottle'),
       ('Minced meat', 5, 'Gram'),
       ('Buns', 6, 'Gram'),
       ('Cheddar', 7, 'Gram'),
       ('Letuce', 8, 'Gram'),
       ('Onion', 9, 'Gram'),
       ('Tomato', 10, 'Gram'),
       ('Cod fillet', 11, 'Gram'),
       ('Chips', 12, 'Gram');

INSERT INTO Buyable (idProduct, price, startSaleDate, endSaleDate)
VALUES (1, 18.50, '2019-01-15', NULL),
       (2, 23.50, '2019-01-15', NULL),
       (3, 4.00, '2019-01-15', NULL),
       (4, 1.00, '2019-01-15', NULL),
       (5, 2.00, '2019-01-15', NULL),
       (6, 2.50, '2019-01-15', NULL);

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
       (6, 5);

INSERT INTO Food
VALUES (1),
       (2);

INSERT INTO Food_Ingredient (idFood, idIngredient, quantity)
VALUES (1, 7, 200),
       (1, 8, 2),
       (1, 9, 10),
       (1, 10, 15),
       (1, 11, 5),
       (1, 12, 5),
       (1, 14, 75),
       (2, 13, 150),
       (2, 14, 75);

-- Happy Hour
INSERT INTO HappyHour (startAt, duration, reductionPercent, idManager)
VALUES ('2019-03-14', '01:00', 10, 2),
       ('2019-03-15', '01:00', 10, 2),
       ('2019-03-16', '01:00', 10, 2);

-- Order
INSERT INTO `Order` (orderAt, tva)
VALUES ('2019-12-06', 7.7),
       ('2019-12-06', 7.7),
       ('2019-04-14', 7.7),
       ('2019-04-14', 7.7);

INSERT INTO CustomerOrder (idOrder, idWaiter, tableNb)
VALUES (1, 3, 10),
       (2, 4, 7);

INSERT INTO Buyable_CustomerOrder (idCustomerOrder, idBuyable, price, quantity)
VALUES (1, 4, 1.00, 16),
       (2, 6, 2.00, 4);

INSERT INTO SupplyOrder (idOrder, idManager, idSupplier)
VALUES (3, 2, 1),
       (4, 2, 1);

INSERT INTO Product_SupplyOrder (idProduct, idSupplyOrder, price, quantity)
VALUES (4, 3, 0.50, 20),
       (5, 4, 1, 10);