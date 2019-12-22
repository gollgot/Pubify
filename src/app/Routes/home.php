<?php

use App\Controllers\HomeController;

$app
    ->get('/', HomeController::class.":homeAction")
    ->setName("home");