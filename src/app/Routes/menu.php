<?php

use App\Controllers\MenuController;

$app
->get('/menu', MenuController::class.":showAction")
->setName("menu");