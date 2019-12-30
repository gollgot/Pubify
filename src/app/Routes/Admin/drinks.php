<?php

use App\Controllers\Admin\DrinkController;
use App\Middlewares\AuthMiddleware;

$app
    ->get('/admin/drinks', DrinkController::class.":indexAction")
    ->setName("admin_drinks_index")
    ->add(new AuthMiddleware($container));
