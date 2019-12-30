<?php

namespace App\Middlewares;

/**
 * Middleware that automatically redirect the user to the sign in page if his not authenticated.
 *
 * Class AuthMiddleware
 * @package App\src\middlewares
 */
class AuthMiddleware extends Middleware
{
    public function __invoke($request, $response, $next){

        // Redirect to login route if the current visitor is not connected
        if(!$this->container->auth->check()){
            return $response->withRedirect($this->container->router->pathFor('auth_get_login'));
        }

        // Continue to the asked route otherwise
        return $next($request, $response);
    }
}