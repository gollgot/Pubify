<?php

use App\Controllers\Admin\DashboardController;
use App\Middlewares\AuthMiddleware;

$app
    ->get('/admin/dashboard', DashboardController::class.":showAction")
    ->setName("admin_dashboard_show")
    ->add(new AuthMiddleware($container));