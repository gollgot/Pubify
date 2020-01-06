<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class IngredientController extends Controller
{
    /**
     * Display the Ingredients index view to show all Ingredients
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all ingredients
        $query = $pdo->query("SELECT product_name, quantity, unit_name FROM vIngredient ORDER BY quantity");
        $ingredients = $query->fetchAll();

        return $this->render($response, 'Admin/Ingredients/index.html.twig', [
            'ingredients' => $ingredients
        ]);
    }

}