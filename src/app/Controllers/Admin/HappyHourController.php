<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
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

        // Fetch all happyhours
        $query = $pdo->query("SELECT name, lastname, duration, reductionPercent, startAt, DATE_FORMAT(startAt, '%d.%m.%Y %H:%i') as startAtFormated FROM HappyHour INNER JOIN Manager ON idManager = idStaff INNER JOIN Staff ON idStaff = id ORDER BY startAt");
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

        return $this->render($response, 'Admin/HappyHours/index.html.twig', [
            'happyhours' => $happyhours
        ]);
    }

}