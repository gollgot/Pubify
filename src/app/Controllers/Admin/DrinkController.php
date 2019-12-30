<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use Slim\Http\Request;
use Slim\Http\Response;

class DrinkController extends Controller
{

    public function indexAction(Request $request, Response $response) {
        $stmt = $this->container->db->query("SELECT product_name, unit_name, quantity, price, DATE_FORMAT(startSaleDate, '%d.%m.%Y %H:%i') as startSaleDate, DATE_FORMAT(endSaleDate, '%d.%m.%Y %H:%i') as endSaleDate, alcoholLevel FROM drinks ORDER BY quantity");
        $drinks = $stmt->fetchAll();

        return $this->render($response, 'Admin/Drink/show.html.twig', [
            'drinks' => $drinks
        ]);
    }

}