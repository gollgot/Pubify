<?php
class Test {
    private $pdo;
    public function __construct()
    {
        $config = include "../app/settings.php";

        $db = $config['settings']['db'];
        $this->pdo = new PDO('mysql:host=' . $db['host'] . ';dbname=' . $db['dbname'],
            $db['user'], $db['pass']);
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $this->pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        $this->pdo->beginTransaction();
    }

    public function endTransaction() {
        $this->pdo->rollback();
    }
    public function testRequest($query) {
        try {
            $query = $this->pdo->prepare($query);
            $query->execute();

            try {
                return arrayToHtmlTable($query->fetchAll());
            } catch (Exception $e) {
                return "OK";
            }
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }
}
function arrayToHtmlTable($array) {

    if(!is_array($array)) return $array;

    $result = "<table cellpadding='3'>";
    foreach ($array as $row) {
        $result .= "<tr>";
        foreach ($row as $col) {
            $result .= "<td>" . $col . "</td>";
        }
        $result .= "</tr>";
    }
    $result .= "</table>";
    return $result;
}

$test = new Test();
$requests = [
    // HappyHours
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 12:12', 1, '-2:00', 12)",
        "result" => "Error: Duration cannot be negative"
    ],
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 12:12', 2, '2:00', 12)",
        "result" => "Error: Only a manager can create an order"
    ],
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 12:12', 1, '2:00', 0)",
        "result" => "Error: Reduction percent needs to be between 1 and 100"
    ],
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 12:12', 1, '2:00', 101)",
        "result" => "Error: Reduction percent needs to be between 1 and 100"
    ],
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 12:12', 1, '2:00', 12)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO HappyHour (startAt, idManager, duration, reductionPercent) VALUES ('2021-12-12 13:12', 1, '2:00', 12)",
        "result" => "Error: Happy hours can't be overlapping"
    ],
    // Drink
    [
        "query" => "INSERT INTO Drink (idBuyable, alcoholLevel) VALUES (1, 12)",
        "result" => "Error: A Drink can't be a food"
    ],
    [
        "query" => "INSERT INTO Drink (idBuyable, alcoholLevel) VALUES (3, -12)",
        "result" => "Error: Alcohol level can't be negative"
    ],
    // Customer Order
    [
        "query" => "INSERT INTO `Order`(id, orderAt, tva) VALUES (50, NOW(), -2)",
        "result" => "Error: TVA cannot be negative"
    ],
    [
        "query" => "INSERT INTO `Order`(id, orderAt, tva) VALUES (50, NOW(), 5)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO CustomerOrder (idOrder, idWaiter, tableNB) VALUES (50, 1, 12)",
        "result" => "Error: A manager cannot take an order"
    ],
    [
        "query" => "INSERT INTO CustomerOrder (idOrder, idWaiter, tableNB) VALUES (50, 2, 12)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO Buyable_CustomerOrder(idBuyable, idCustomerOrder, price, quantity) VALUES (1, 50, 12.5, 26)",
        "result" => "Error: Not enough stock for the order"
    ],
    [
        "query" => "INSERT INTO Buyable_CustomerOrder(idBuyable, idCustomerOrder, price, quantity) VALUES (5, 50, 12.5, 26)",
        "result" => "Error: Not enough stock for the order"
    ],
    [
        "query" => "INSERT INTO Buyable_CustomerOrder(idBuyable, idCustomerOrder, price, quantity) VALUES (16, 50, 12.5, 2)",
        "result" => "Error: Not buyable during the date of the order"
    ],
    // Supply Order
    [
        "query" => "INSERT INTO `Order`(id, orderAt, tva) VALUES (51, NOW(), 5)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO SupplyOrder(idOrder, idSupplier, idManager) VALUES (50, 1, 2)",
        "result" => "Error: A SupplyOrder can't be a CustomerOrder"
    ],
    [
        "query" => "INSERT INTO SupplyOrder(idOrder, idSupplier, idManager) VALUES (51, 1, 2)",
        "result" => "Error: A Waiter can't take a supply order"
    ],
    [
        "query" => "INSERT INTO SupplyOrder(idOrder, idSupplier, idManager) VALUES (51, 1, 1)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO Product_SupplyOrder(idProduct, idSupplyOrder, price, quantity) VALUES (1, 51, 12, 5)",
        "result" => "Error: can't order a composed food"
    ],
    [
        "query" => "INSERT INTO `Order`(id, orderAt, tva) VALUES (52, NOW(), 5)",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO CustomerOrder(idOrder, idWaiter, tableNB) VALUES (52, 4, 12)",
        "result" => "Error: A deleted Staff cannot create an order"
    ],
    [
        "query" => "INSERT INTO SupplyOrder(idOrder, idSupplier, idManager) VALUES (52, 1, 3)",
        "result" => "Error: A deleted Staff cannot create an order"
    ],
    [
        "query" => "INSERT INTO Buyable_CustomerOrder(idBuyable, idCustomerOrder, price, quantity) VALUES (1, 50, -12, 2)",
        "result" => "Error: Price can't be negative"
    ],
    [
        "query" => "INSERT INTO Buyable_CustomerOrder(idBuyable, idCustomerOrder, price, quantity) VALUES (1, 50, 12, 0)",
        "result" => "Error: Quantity can't be less than 1"
    ],
    [
        "query" => "INSERT INTO Product_SupplyOrder(idProduct, idSupplyOrder, price, quantity) VALUES (3, 51, -12, 5)",
        "result" => "Error: Price can't be negative"
    ],
    [
        "query" => "INSERT INTO Product_SupplyOrder(idProduct, idSupplyOrder, price, quantity) VALUES (3, 51, 12, 0)",
        "result" => "Error: Quantity can't be less than 1"
    ],
    [
        "query" => "INSERT INTO Food_Ingredient(idFood, idIngredient, quantity) VALUES (1, 7, -2)",
        "result" => "Error: Quantity can't be less than 1"
    ],
    [
        "query" => "INSERT INTO Product(id, name, nameUnitMetric) VALUES (50, 'test', 'Bouteille')",
        "result" => "OK"
    ],
    [
        "query" => "INSERT INTO Buyable(idProduct, price, startSaleDate) VALUES (50, -1, NOW())",
        "result" => "Error: Price can't be negative"
    ],
    [
        "query" => "INSERT INTO Buyable(idProduct, price, startSaleDate, endSaleDate) VALUES (50, 12, NOW(), NOW() - 2)",
        "result" => "Error: Starting sale date can't be greater than the ending date"
    ],
    [
        "query" => "INSERT INTO Drink_HappyHour(idDrink, startAtHappyHour) VALUES (16, '2021-12-12 12:12')",
        "result" => "Error: Chosen drink can't be sold during the whole happy hour"
    ],
    [
        "query" => "UPDATE HappyHour SET duration='-2:00' WHERE startAt = '2021-12-12 12:12'",
        "result" => "Error: Duration can't be negative"
    ],
    [
        "query" => "UPDATE HappyHour SET startAt = '2020-03-17 18:00:00' WHERE startAt = '2021-12-12 12:12'",
        "result" => "Error: Happy hours can't be overlapping"
    ],
    [
        "query" => "UPDATE HappyHour SET reductionPercent = 0 WHERE startAt = '2021-12-12 12:12'",
        "result" => "Error: Reduction percent needs to be between 1 and 100"
    ],
    [
        "query" => "UPDATE HappyHour SET reductionPercent = 101 WHERE startAt = '2021-12-12 12:12'",
        "result" => "Error: Reduction percent needs to be between 1 and 100"
    ],
    [
        "query" => "UPDATE Drink SET alcoholLevel = -2 WHERE idBuyable = 3",
        "result" => "Error: Alcohol level can't be negative"
    ],
    [
        "query" => "UPDATE CustomerOrder SET idWaiter = 1 WHERE idOrder = 50",
        "result" => "Error: Manager can't take a customerOrder"
    ],
    [
        "query" => "UPDATE SupplyOrder SET idManager = 2 WHERE idOrder = 51",
        "result" => "Error: Deleted waiter cannot take an order"
    ],
    [
        "query" => "UPDATE CustomerOrder SET idWaiter = 4 WHERE idOrder = 50",
        "result" => "Error: A delete staff can't take an order"
    ],
    [
        "query" => "UPDATE SupplyOrder SET idManager = 3 WHERE idOrder = 51",
        "result" => "Error: Deleted waiter cannot take an order"
    ],
    [
        "query" => "UPDATE Manager SET active = 0 WHERE idStaff = 1",
        "result" => "Error: Cannot delete the last waiter"
    ],
    [
        "query" => "UPDATE Stock SET quantity = -2 WHERE idProduct = 3",
        "result" => "Error: quantity can't be negative"
    ],
    [
        "query" => "UPDATE Buyable SET price = -2 WHERE idProduct = 3",
        "result" => "Error: price can't be negative"
    ],
    [
        "query" => "UPDATE Buyable SET endSaleDate = '2019-01-15 08:00:00' WHERE idProduct = 3",
        "result" => "Error: Starting sale date can't be greater than the ending date"
    ],

];
?>

<html>
    <head>
        <title>Pubify db Tests</title>
    </head>
    <body>
        <table border="1" cellpadding="12">
            <caption>Results</caption>
            <tr>
                <th>Nb°</th>
                <th>Request</th>
                <th>Expected Result</th>
                <th>Query Result</th>
            </tr>
            <?php $i = 0?>
            <?php foreach ($requests as $request){?>
                <tr>
                    <td><?=++$i?></td>
                    <td><pre><?=$request["query"]?></pre></td>
                    <td><?=arrayToHtmlTable($request["result"])?></td>
                    <td><?=$test->testRequest($request["query"])?></td>
                </tr>
            <?php }?>
        </table>
    </body>
</html>
<?php $test->endTransaction();?>