<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require '../vendor/autoload.php';

// General configuration
$settings = require('../app/settings.php');

// Create the app
$app = new \Slim\App($settings);

// Container loading
require('../app/container.php');

// Routes
require '../app/Routes/home.php';


$app->run();