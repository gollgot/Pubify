<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use Slim\Http\Request;
use Slim\Http\Response;

class DashboardController extends Controller
{
    public function showAction(Request $request, Response $response) {
        return $this->render($response, 'Admin/Dashboard/show.html.twig', []);
    }
}