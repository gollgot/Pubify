<?php

use App\Controllers\HappyHourController;

$app
    ->get('/happyhours', HappyHourController::class.":indexAction")
    ->setName("happyhours_index");