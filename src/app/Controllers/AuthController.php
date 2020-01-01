<?php

namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class AuthController extends Controller
{

    /**
     * Display the login form
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function getLogin(Request $request, Response $response){
        return $this->render($response, 'Auth/login.html.twig', []);
    }

    /**
     * Attempt to connect the user
     *
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function postLogin(Request $request, Response $response)
    {
        if ($this->container->auth->attempt($request->getParam('email'), $request->getParam('password'))) {
            return $response->withRedirect($this->container->router->pathFor('admin_dashboard'));
        } else {
            // If error when auth attempt => display flash error and last email to the login page
            $this->container->flash->addMessage('error', 'Invalid email or password');
            $this->container->flash->addMessage('lastEmail', $request->getParam("email"));

            return $response->withRedirect($this->container->router->pathFor('auth_get_login'));
        }
    }

    public function getLogout(Request $request, Response $response){
        $this->container->auth->logout();
        return $response->withRedirect($this->container->router->pathFor('home'));
    }

}