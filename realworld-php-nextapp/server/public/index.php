<?php
declare(strict_types=1);

require __DIR__.'/../vendor/autoload.php';

use League\Route\RouteGroup;
use Psr\Http\Message\ServerRequestInterface;

$request = Laminas\Diactoros\ServerRequestFactory::fromGlobals(
  $_SERVER,
  $_GET,
  $_POST,
  $_COOKIE,
  $_FILES
);

$responseFactory = new Laminas\Diactoros\ResponseFactory();

$strategy = new League\Route\Strategy\JsonStrategy($responseFactory);
$router = (new League\Route\Router);
$router->setStrategy($strategy);

$router->group('/api', function ($route) {
  $route->get('/health-check', function (ServerRequestInterface $request): array {
    return [
      'title' => 'My New Simple API',
      'version' => 1,
    ];
  });
});

$response = $router->dispatch($request);

// send the response to the browser
(new Laminas\HttpHandlerRunner\Emitter\SapiEmitter)->emit($response);