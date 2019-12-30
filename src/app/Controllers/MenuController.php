<?php

namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class MenuController extends Controller
{

    public function showAction(Request $request, Response $response) {
        return $this->render($response, 'Menu/show.html.twig', []);
    }

}