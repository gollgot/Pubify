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

INSERT INTO Product (name, nameUnitMetric)
VALUES ('Classic Beef Burger', 'Gram'),
       ('Fish \'N\' Chips', 'Gram'),
       ('Dr. Gabs', 'Bottle'),
       ('Farmer', 'Can'),
       ('Ginger Ale', 'Bottle'),
       ('Cuvée des Trolls', 'Bottle'),
       ('Minced meat', 'Gram'),
       ('Buns', 'Gram'),
       ('Cheddar', 'Gram'),
       ('Letuce', 'Gram'),
       ('Onion', 'Gram'),
       ('Tomato', 'Gram'),
       ('Cod fillet', 'Gram'),
       ('Chips', 'Gram');

INSERT INTO Stock (quantity, idProduct)
VALUES (22, 3),
       (4, 4),
       (16, 5),
       (2, 6),
       (2000, 7),
       (10, 8),
       (200, 9),
       (2000, 10),
       (500, 11),
       (500, 12),
       (2000, 13),
       (4000, 14);

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
VALUES ('2019-03-14 16:15', '01:00', 10, 2),
       ('2019-03-15 21:25', '01:00', 10, 2),
       ('2019-03-16 23:18', '01:00', 10, 2);

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