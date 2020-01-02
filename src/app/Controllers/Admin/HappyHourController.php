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

        $query = $pdo->query("SELECT name, lastname, duration, reductionPercent, DATE_FORMAT(startAt, '%d.%m.%Y %H:%i') as startAt FROM HappyHour INNER JOIN Manager ON idManager = idStaff INNER JOIN Staff ON idStaff = id ORDER BY startAt");
        $happyhours = $query->fetchAll();

        return $this->render($response, 'Admin/HappyHours/index.html.twig', [
            'happyhours' => $happyhours
        ]);
    }


    /**
     * Check if the value is empty (zero exclude)
     *
     * @param $val
     * @return bool
     */
    private function is_empty($val) {
        return empty($val) && $val !== "0";
    }

}