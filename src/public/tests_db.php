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