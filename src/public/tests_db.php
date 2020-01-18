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
    }

    public function testRequest($query) {
        try {
            $this->pdo->beginTransaction();
            $query = $this->pdo->query($query);
            $this->pdo->commit();

            try {
                return arrayToHtmlTable($query->fetchAll());
            } catch (Exception $e) {
                return "OK";
            }
        } catch (PDOException $e) {
            $this->pdo->rollback();
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
                <th>Request</th>
                <th>Expected Result</th>
                <th>Query Result</th>
            </tr>
            <?php foreach ($requests as $request){?>
                <tr>
                    <td><pre><?=$request["query"]?></pre></td>
                    <td><?=arrayToHtmlTable($request["result"])?></td>
                    <td><?=$test->testRequest($request["query"])?></td>
                </tr>
            <?php }?>
        </table>
    </body>
</html>