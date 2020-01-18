<?php

use App\Controllers\Admin\CustomerOrderController;
use App\Middlewares\AuthMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/customer-orders', CustomerOrderController::class.":indexAction")
        ->setName("admin_customer-orders_index");
    $this
        ->get('/customer-orders/create', CustomerOrderController::class.":createAction")
        ->setName("admin_customer-orders_create");
    $this
        ->post('/customer-orders', CustomerOrderController::class.":storeAction")
        ->setName("admin_customer-orders_store");
})
    ->add(new AuthMiddleware($container));