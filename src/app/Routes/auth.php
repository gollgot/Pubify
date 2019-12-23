<?php

use App\Controllers\AuthController;

$app
    ->get('/login', AuthController::class.":getLogin")
    ->setName("auth_get_login");

$app
    ->post('/login', AuthController::class.":postLogin")
    ->setName("auth_post_login");

$app
    ->get('/logout', AuthController::class.":getLogout")
    ->setName("auth_get_logout");