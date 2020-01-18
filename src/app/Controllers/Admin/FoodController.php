<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class FoodController extends Controller
{
    /**
     * Display the food index view to show all Foods
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;
        $query = $pdo->query("SELECT product_name, quantity, price, DATE_FORMAT(startSaleDate, '%d.%m.%Y %H:%i') as startSaleDate, DATE_FORMAT(endSaleDate, '%d.%m.%Y %H:%i') as endSaleDate FROM vStockableFood ORDER BY quantity");
        // Fetch all foods
        $foods = $query->fetchAll();

        return $this->render($response, 'Admin/Foods/index.html.twig', [
            'foods' => $foods
        ]);
    }

}