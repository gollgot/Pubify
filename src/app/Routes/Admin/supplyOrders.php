<?php

use App\Controllers\Admin\SupplyOrderController;
use App\Middlewares\AuthMiddleware;
use App\Middlewares\HasRoleMiddleware;

// the keyword "use" -> to do a parameter inheritance to a closure
$app->group('/admin', function () use ($container) {
    $this
        ->get('/supply-orders', SupplyOrderController::class.":indexAction")
        ->setName("admin_supply-orders_index");
    $this
        ->get('/supply-orders/create', SupplyOrderController::class.":createAction")
        ->setName("admin_supply-orders_create");
    $this
        ->post('/supply-orders', SupplyOrderController::class.":storeAction")
        ->setName("admin_supply-orders_store");
})
    ->add(new AuthMiddleware($container))
    ->add(new HasRoleMiddleware($container, "manager"));