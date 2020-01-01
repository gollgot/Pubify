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
        return $this->render($response, 'Menu/index.html.twig', []);
    }

}