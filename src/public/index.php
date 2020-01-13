<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

session_start();

require '../vendor/autoload.php';

// General configuration
$settings = require('../app/settings.php');

// Create the app
$app = new \Slim\App($settings);

// Container loading
require('../app/container.php');

// Routes
require '../app/Routes/home.php';
require '../app/Routes/auth.php';
require '../app/Routes/menu.php';
require '../app/Routes/happyhours.php';
require '../app/Routes/Admin/dashboard.php';
require '../app/Routes/Admin/drinks.php';
require '../app/Routes/Admin/happyhours.php';
require '../app/Routes/Admin/ingredients.php';


$app->run();