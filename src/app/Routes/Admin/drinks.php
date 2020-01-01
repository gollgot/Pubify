<?php

use App\Controllers\Admin\DrinkController;
use App\Middlewares\AuthMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/admin/drinks', DrinkController::class.":indexAction")
        ->setName("admin_drinks_index");
    $this
        ->get('/admin/drinks/create', DrinkController::class.":createAction")
        ->setName("admin_drinks_create");
    $this
        ->post('/admin/drinks', DrinkController::class.":storeAction")
        ->setName("admin_drinks_store");
})->add(new AuthMiddleware($container));