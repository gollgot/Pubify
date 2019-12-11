-- Staff
INSERT INTO Staff (email, name, lastname, password)
VALUES 	('john.snow@pubify.com', 'John', 'Snow', '.Etml-1'),
		('daenerys.targaryen@pubify.com', 'Daenerys', 'Targaryen', '.Etml-1'),
        ('obiwan.kenobi@pubify.com', 'Obi Wan', 'Kenobi', '.Etml-1'),
        ('darth.vader@pubify.com', 'Darth', 'Vader', '.Etml-1');

INSERT INTO Waiter
VALUES 	(1),
		(3),
        (4);

INSERT INTO Manager
VALUES	(2);

INSERT INTO Supplier (name)
VALUES 	('Aligro'),
		('Dr. Gabs');

-- Product
INSERT INTO UnitMetric (name, shortname)
VALUES	('Gram', 'g'),
		('Litre', 'l'),
        ('Bottle', 'bt'),
        ('Can', 'can');
INSERT INTO Stock (quantity)
VALUES	(22),
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

INSERT INTO Product (name, idStock)
VALUES	('Classic Beef Burger', NULL),
		('Fish \'N\' Chips', NULL),
        ('Dr. Gabs', 1),
        ('Farmer', 2),
        ('Giger Ale', 3),
        ('Cuvée des Trolls', 4),
        ('Minced meat', 5),
        ('Buns', 6),
        ('Cheddar', 7),
        ('Letuce', 8),
        ('Onion', 9),
        ('Tomato', 10),
        ('Cod fillet', 11),
        ('Chips', 12);
        
INSERT INTO Buyable (idProduct, price, startSellDate, endSellDate)
VALUES	(1, 18.50, '2019-01-15', NULL),
		(2, 23.50, '2019-01-15', NULL),
		(3, 4.00, '2019-01-15', NULL),
        (4, 1.00, '2019-01-15', NULL),
        (5, 2.00, '2019-01-15', NULL),
        (6, 2.50, '2019-01-15', NULL);
        
INSERT INTO Ingredient
VALUES 	(7),
        (8),
        (9),
        (10),
        (11),
        (12),
        (13),
        (14);

INSERT INTO Drink (idBuyable, alcoholLevel)
VALUES 	(3, 5),
		(4, 5),
		(5, 0),
        (6, 5);

INSERT INTO Food
VALUES	(1),
		(2);

INSERT INTO Food_Ingredient (idFood, idIngredient, quantity)
VALUES 	(1, 7, 200),
		(1, 8, 2),
        (1, 9, 10),
        (1, 10, 15),
        (1, 11, 5),
        (1, 12, 5),
        (1, 14, 75),
        (2, 13, 150),
        (2, 14, 75);

INSERT INTO HappyHour (startAt, duration, reductionPercent, idManager, reductionPercent)
VALUES	('2019-03-14', '01:00', 10, 2, 3),
		('2019-03-14', '01:00', 10, 2, 4),
        ('2019-03-14', '01:00', 10, 2, 6);


INSERT INTO Order (orderAt, tva)
VALUES	('2019-12-06', 7.7),
		('2019-12-06', 7.7),
        ('2019-04-14', 7.7),
        ('2019-04-14', 7.7);

INSERT INTO CustomerOrder (idOrder, idWaiter, tableNb)
VALUES	(1, 3, 10),
		(2, 4, 7);


INSERT INTO Buyable_CustomerOrder (idCustomerOrder, idBuyable, price, quantity)
VALUES	(1, ),
		();
        
        