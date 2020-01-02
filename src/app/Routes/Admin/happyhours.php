<?php

use App\Controllers\Admin\HappyHourController;
use App\Middlewares\AuthMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/admin/happyhours', HappyHourController::class.":indexAction")
        ->setName("admin_happyhours_index");
})->add(new AuthMiddleware($container));