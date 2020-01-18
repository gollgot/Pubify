<?php

use App\Controllers\Admin\ComposedFoodController;
use App\Middlewares\AuthMiddleware;
use App\Middlewares\HasRoleMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/composed-foods', ComposedFoodController::class.":indexAction")
        ->setName("admin_composed-foods_index");
})
    ->add(new AuthMiddleware($container))
    ->add(new HasRoleMiddleware($container, "manager"));