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


            $query = $pdo->prepare('SELECT SUM(Buyable_CustomerOrder.price) as totalPrice FROM Buyable_CustomerOrder INNER JOIN vBuyable ON vBuyable.id = idBuyable WHERE idCustomerOrder = :idOrder');
            $query->execute([
                'idOrder' => $orders[$i]['id']
            ]);
            
            $totalPriceWithoutTVA = $query->fetch();
            $orders[$i]['totalPrice'] = $totalPriceWithoutTVA + ($totalPriceWithoutTVA * $orders[$i]['tva'] / 100);

        }

        return $this->render($response, 'Admin/CustomerOrders/index.html.twig', [
            'orders' => $orders
        ]);
    }

    /**
     * Display the supply order create view to be able to create a new supply order
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function createAction(Request $request, Response $response) {

    }

    /**
     * Store a new supply order created by the user
     *
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function storeAction(Request $request, Response $response)
    {

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