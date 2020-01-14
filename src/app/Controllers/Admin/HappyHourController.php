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

    /**
     * Display the happyhour create view to be able to create a new happyhour
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function createAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all drinks that can be
        $query = $pdo->query("SELECT product_name, id FROM vDrink");
        $drinks = $query->fetchAll();

        return $this->render($response, 'Admin/HappyHours/create.html.twig', [
            'drinks' => $drinks
        ]);
    }

    /**
     * Store the happyhour with his related drinks
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function storeAction(Request $request, Response $response) {
        $pdo = $this->container->db;

        $idManager = $this->container->auth->user()["id"];
        $start = $request->getParam("startAt");
        $duration = $request->getParam("duration");
        $reduction = $request->getParam("reduction");
        $drinks = $request->getParam("drinks");

        $error = false; // todo: validate params

        if (!$error) {
            try {
                $pdo->beginTransaction();

                // Query 1: insert happyHour
                $query = $pdo->prepare("INSERT INTO HappyHour(startAt, idManager, duration, reductionPercent) VALUES (:startAt, :idManager, :duration, :reductionPercent)");
                $query->execute([
                   ":startAt" => $start,
                   ":idManager" => $idManager,
                   ":duration" => $duration,
                   ":reductionPercent" => $reduction
                ]);

                // Query 2: insert drinks
                foreach($drinks as $drink) {
                    $query = $pdo->prepare("INSERT INTO Drink_HappyHour(idDrink, startAtHappyHour) VALUES (:idDrink, :startAtHappyHour)");
                    $query->execute([
                        ":idDrink" => $drink,
                        ":startAtHappyHour" => $start
                    ]);
                }
            } catch (PDOException $e) {
                //An exception has occured, which means that one of our database queries failed => Rollback
                $error = true;
                $pdo->rollback();

            }
        }
        // Error detected -> display flash message
        if($error){
            $this->container->flash->addMessage('error', 'Une erreur est survenue, veuillez vérifier vos données.');
            return $response->withRedirect($this->container->router->pathFor('admin_happyhours_create'));
        }

        // No error
        $this->container->flash->addMessage('success', 'La happy hour du "'.$request->getParam('startAt').'" à bien été ajoutée.');
        return $response->withRedirect($this->container->router->pathFor('admin_happyhours_index'));
    }

}