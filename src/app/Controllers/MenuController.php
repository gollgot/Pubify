<?php

namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class MenuController extends Controller
{

    /**
     * Display the Menu show view
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function showAction(Request $request, Response $response) {
        $pdo = $this->container->db;

        $query = $pdo->query("SELECT product_name, price FROM vFood WHERE endSaleDate >= NOW() OR endSaleDate IS NULL");
        $foods = $query->fetchAll();

        $query = $pdo->query("SELECT product_name, price, alcoholLevel, quantity FROM vDrink WHERE alcoholLevel > 0.0 AND (endSaleDate >= NOW() OR endSaleDate IS NULL) ORDER BY quantity DESC");
        $drinksWithAlcohol = $query->fetchAll();

        $query = $pdo->query("SELECT product_name, price, quantity FROM vDrink WHERE alcoholLevel = 0.0 AND (endSaleDate >= NOW() OR endSaleDate IS NULL) ORDER BY quantity DESC");
        $drinksWithoutAlcohol = $query->fetchAll();

        return $this->render($response, 'Menu/show.html.twig', [
            'foods' => $foods,
            'drinksWithAlcohol' => $drinksWithAlcohol,
            'drinksWithoutAlcohol' => $drinksWithoutAlcohol,
        ]);
    }

}