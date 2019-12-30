<?php

use App\Controllers\Admin\DrinkController;
use App\Middlewares\AuthMiddleware;

$app
    ->get('/admin/drinks', DrinkController::class.":showAction")
    ->setName("admin_drinks_show")
    ->add(new AuthMiddleware($container));
