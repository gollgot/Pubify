<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class CustomerOrderController extends Controller
{
    /**
     * Display the customer orders index view to show all customer orders
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all customer orders
        $query = $pdo->query("SELECT id, orderAt, name, lastname, tva, DATE_FORMAT(orderAt, '%d.%m.%Y %H:%i') as orderAtFormated FROM vCustomerOrder ORDER BY orderAt DESC");
        $orders = $query->fetchAll();

        // For each customer order, fetch his linked products and total price and add them to the orders array to pass them to the view
        for($i = 0; $i < count($orders); ++$i){
            $query = $pdo->prepare('SELECT product_name, Buyable_CustomerOrder.quantity, Buyable_CustomerOrder.price FROM Buyable_CustomerOrder INNER JOIN vBuyable ON vBuyable.id = idBuyable WHERE idCustomerOrder = :idOrder');
            $query->execute([
                'idOrder' => $orders[$i]['id']
            ]);
            $linkedProducts = $query->fetchAll();
            $orders[$i]['linkedProducts'] = $linkedProducts;


            $query = $pdo->prepare('SELECT SUM(Buyable_CustomerOrder.price * Buyable_CustomerOrder.quantity) as totalPrice FROM Buyable_CustomerOrder INNER JOIN vBuyable ON vBuyable.id = idBuyable WHERE idCustomerOrder = :idOrder');
            $query->execute([
                'idOrder' => $orders[$i]['id']
            ]);

            $totalPriceWithoutTVA = $query->fetch()['totalPrice'];
            $orders[$i]['totalPrice'] = round($totalPriceWithoutTVA + ($totalPriceWithoutTVA * $orders[$i]['tva'] / 100), 2);
        }


        return $this->render($response, 'Admin/CustomerOrders/index.html.twig', [
            'orders' => $orders
        ]);
    }

    /**
     * Display the customer order create view to be able to create a new customer order
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function createAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        $query = $pdo->query("SELECT id, product_name, unit_name FROM vBuyable WHERE (NOW() BETWEEN startSaleDate AND endSaleDate) || (NOW() >= startSaleDate AND endSaleDate IS NULL) ");
        $buyables = $query->fetchAll();

        return $this->render($response, 'Admin/CustomerOrders/create.html.twig', [
            'buyables' => $buyables,
        ]);
    }

    /**
     * Store a new customer order created by the user
     *
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function storeAction(Request $request, Response $response)
    {
        $table = $request->getParam("table");
        $tva = $request->getParam("tva");
        $productsId = $request->getParam("productsId");
        $quantities = $request->getParam("quantities");

        $error = false;

        // Check the required / NOT NULL fields
        if ($this->is_empty($table) || $this->is_empty($tva)) {
            $error = true;
        }

        for($i = 0; $i < count($productsId); ++$i){
            if($this->is_empty($productsId[$i] || $this->is_empty($quantities[$i]))){
                $error = true;
                break;
            }
        }

        if(!$error){
            // Fetch the pdo connection from the container dependency
            $pdo = $this->container->db;

            try{
                // Start our transaction
                $pdo->beginTransaction();

                // Query 1: Insert the new Order
                $query = $pdo->prepare("INSERT INTO `Order`(orderAt, tva) VALUES(NOW(), :tva)");
                $query->execute([
                    ':tva' => $tva
                ]);
                $orderId = $pdo->lastInsertId();

                // Query2 : Insert the CustomerOrder
                $query = $pdo->prepare("INSERT INTO CustomerOrder(idOrder, idWaiter, tableNB) VALUES(:idOrder, :idWaiter, :tableNB)");
                $query->execute([
                    ':idOrder' => $orderId,
                    ':idWaiter' => $this->container->auth->user()['id'],
                    ':tableNB' => $table
                ]);

                // Query3 : Insert the Buyable_CustomerOrder
                for($i = 0; $i < count($productsId); ++$i){
                    // Fetch the product price
                    $query = $pdo->prepare("SELECT price FROM Buyable WHERE idProduct = :idProduct");
                    $query->execute([
                        ':idProduct' => $productsId[$i]
                    ]);
                    $price = $query->fetch()['price'];

                    $query = $pdo->prepare("INSERT INTO Buyable_CustomerOrder(idCustomerOrder, idBuyable, price, quantity) VALUES(:idCustomerOrder, :idBuyable, :price, :quantity)");
                    $query->execute([
                        ':idCustomerOrder' => $orderId,
                        ':idBuyable' => $productsId[$i],
                        ':price' => $price,
                        ':quantity' => $quantities[$i]
                    ]);
                }

                // No exception has occured, so commit the changes.
                $pdo->commit();

            } catch (PDOException $exception) {
                //An exception has occured, which means that one of our database queries failed => Rollback
                $error = true;
                $pdo->rollback();
            }
        }

        // Error detected -> display flash message
        if($error){
            $this->container->flash->addMessage('error', 'Une erreur est survenue, veuillez vérifier vos données.');
            return $response->withRedirect($this->container->router->pathFor('admin_customer-orders_create'));
        }

        // No error
        $this->container->flash->addMessage('success', 'La commande client à bien été ajoutée.');
        return $response->withRedirect($this->container->router->pathFor('admin_customer-orders_index'));
    }


    /**
     * Check if the value is empty (zero exclude)
     *
     * @param $val
     * @return bool
     */
    private function is_empty($val) {
        return empty($val) && $val !== "0";
    }

}