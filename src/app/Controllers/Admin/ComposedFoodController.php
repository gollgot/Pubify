<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class ComposedFoodController extends Controller
{
    /**
     * Display the Composed Food index view to show all composedFoods
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;
        $query = $pdo->query("SELECT product_name, quantity, price, DATE_FORMAT(startSaleDate, '%d.%m.%Y %H:%i') as startSaleDate, DATE_FORMAT(endSaleDate, '%d.%m.%Y %H:%i') as endSaleDate FROM vNonstockableFood ORDER BY quantity");
        // Fetch all composed foods
        $foods = $query->fetchAll();

        return $this->render($response, 'Admin/ComposedFoods/index.html.twig', [
            'foods' => $foods
        ]);
    }

}