<?php

namespace App\Middlewares;

/**
 * Middleware that check if the connected user has the asked role in constructor. Used to protect some pages,
 * Throw a 403 forbidden error if he has'nt the good role.
 */
class HasRoleMiddleware extends Middleware
{

    private $role;

    public function __construct($container, $role)
    {
        parent::__construct($container);
        $this->role = $role;
    }

    public function __invoke($request, $response, $next){

        if($this->container->auth->hasRole($this->role)){
            $response = $next($request, $response);
        }else{
            $response = $response->withStatus(403);
        }

        return $response;
    }
}