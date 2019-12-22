<?php

namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class HomeController extends Controller
{
    public function HomeAction(Request $request, Response $response) {
        return $this->render($response, 'Home/home.twig.html', [
            'nom' => 'Loic'
        ]);
    }

}