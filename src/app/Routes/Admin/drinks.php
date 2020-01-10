<?php

use App\Controllers\Admin\DrinkController;
use App\Middlewares\AuthMiddleware;
use App\Middlewares\HasRoleMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/drinks', DrinkController::class.":indexAction")
        ->setName("admin_drinks_index");
    $this
        ->get('/drinks/create', DrinkController::class.":createAction")
        ->setName("admin_drinks_create");
    $this
        ->post('/drinks', DrinkController::class.":storeAction")
        ->setName("admin_drinks_store");
})
    ->add(new AuthMiddleware($container))
    ->add(new HasRoleMiddleware($container, "manager"));