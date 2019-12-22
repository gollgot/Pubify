<?php

namespace App\Controllers;

use Slim\Http\Response;

class Controller
{
    protected $container;

    public function __construct($container) {
        $this->container = $container;
    }

    /**
     * Render a Twig view. We use the View key in the container.
     *
     * @param Response $response
     * @param $viewPath
     * @param array $args
     * @return mixed
     */
    public function render(Response $response, $viewPath, $args = []){
        return $this->container->view->render($response, $viewPath, $args);
    }

}