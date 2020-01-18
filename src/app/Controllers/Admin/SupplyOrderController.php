<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class SupplyOrderController extends Controller
{
    /**
     * Display the supply orders index view to show all supply orders
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all supply orders
        $query = $pdo->query("SELECT orderAt, manager_name, manager_lastname, supplier_name, tva, DATE_FORMAT(orderAt, '%d.%m.%Y %H:%i') as orderAtFormated FROM vSupplyOrder ORDER BY orderAt");
        $orders = $query->fetchAll();

        return $this->render($response, 'Admin/SupplyOrders/index.html.twig', [
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
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        $query = $pdo->query("SELECT * FROM Supplier");
        $suppliers = $query->fetchAll();

        $query = $pdo->query("SELECT product_name, unit_name FROM vStockableProduct");
        $products = $query->fetchAll();

        return $this->render($response, 'Admin/SupplyOrders/create.html.twig', [
            'suppliers' => $suppliers,
            'products' => $products
        ]);
    }

}