<?php

use Twig\TwigFunction;

$container = $app->getContainer();

// DB connection
$container['db'] = function ($c) {
    $db = $c['settings']['db'];
    $pdo = new PDO('mysql:host=' . $db['host'] . ';dbname=' . $db['dbname'],
        $db['user'], $db['pass']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    return $pdo;
};

// Flash messages => http://www.slimframework.com/docs/v3/features/flash.html
$container['flash'] = function () {
    return new \Slim\Flash\Messages();
};

// Twig view
$container['view'] = function ($container) {
    $appDir = dirname(__DIR__);

    $view = new \Slim\Views\Twig($appDir.'/app/Views', [
        'cache' => false
    ]);

    // Instantiate and add Slim specific extension
    $router = $container->get('router');
    $uri = \Slim\Http\Uri::createFromEnvironment(new \Slim\Http\Environment($_SERVER));
    $view->addExtension(new \Slim\Views\TwigExtension($router, $uri));
    // Add 2 twig global variables one is check => boolean, one is user => array
    // use : {{ auth.check }}, {{ auth.user }}
    $view->getEnvironment()->addGlobal('auth', [
        'check' => $container->auth->check(),
        'user' => $container->auth->user(),
    ]);
    $view->getEnvironment()->addGlobal('flash', $container->flash);

    // Add a new twig function to check if the connected user has the asked role or not
    $funcHasRole = new TwigFunction('hasRole', function($role) use ($container) {
        return $container['auth']->hasRole($role);
    });
    $view->getEnvironment()->addFunction($funcHasRole);

    return $view;
};

// Auth management
$container['auth'] = function ($container) {
    return new App\Auth\Auth($container);
};