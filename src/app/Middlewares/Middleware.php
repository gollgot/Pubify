<?php


namespace App\Middlewares;

/**
 * Parent middleware who take the container to his constructor, this way all child can access it
 * @package App\Middlewares
 */
class Middleware
{
    protected $container;

    public function __construct($container)
    {
        $this->container = $container;
    }
}