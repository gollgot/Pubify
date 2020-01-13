<?php


namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;

class HappyHourController extends Controller
{
    /**
     * Display the happyhours index view to show all happyhours
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all next happyhours (date >= now())
        $query = $pdo->query("SELECT duration, reductionPercent, startAt, DATE_FORMAT(startAt, '%d.%m.%Y %H:%i') as startAtFormated FROM HappyHour WHERE startAt + duration >= NOW() ORDER BY startAt");
        $happyhours = $query->fetchAll();

        // For each happy hour, fetch his linked drinks and add them to the happyHour array to pass them to the view
        for($i = 0; $i < count($happyhours); ++$i){
            $query = $pdo->prepare('SELECT vDrink.product_name FROM Drink_HappyHour INNER JOIN vDrink ON idDrink = vDrink.id  WHERE startAtHappyHour = :startAt');
            $query->execute([
                'startAt' => $happyhours[$i]['startAt']
            ]);
            $linkedDrinks = $query->fetchAll();
            $happyhours[$i]['linkedDrinks'] = $linkedDrinks;
        }

        return $this->render($response, 'HappyHours/index.html.twig', [
            'happyhours' => $happyhours
        ]);
    }

}