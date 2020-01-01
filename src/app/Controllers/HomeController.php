<?php

namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class HomeController extends Controller
{

    /**
     * Display the home view
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function HomeAction(Request $request, Response $response) {
        return $this->render($response, 'Home/home.html.twig', []);
    }

}