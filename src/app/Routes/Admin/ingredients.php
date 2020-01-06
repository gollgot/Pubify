<?php

use App\Controllers\Admin\IngredientController;
use App\Middlewares\AuthMiddleware;
use App\Middlewares\HasRoleMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/ingredients', IngredientController::class.":indexAction")
        ->setName("admin_ingredients_index");
})
    ->add(new AuthMiddleware($container))
    ->add(new HasRoleMiddleware($container, "manager"));