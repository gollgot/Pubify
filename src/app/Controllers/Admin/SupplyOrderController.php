<?php


namespace App\Controllers\Admin;

use App\Controllers\Controller;
use PDOException;
use Slim\Http\Request;
use Slim\Http\Response;

class SupplyOrderController extends Controller
{
    /**
     * Display the supply orders index view to show all supply orders
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function indexAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        // Fetch all supply orders
        $query = $pdo->query("SELECT id, orderAt, manager_name, manager_lastname, supplier_name, tva, DATE_FORMAT(orderAt, '%d.%m.%Y %H:%i') as orderAtFormated FROM vSupplyOrder ORDER BY orderAt DESC");
        $orders = $query->fetchAll();

        // For each supply order, fetch his linked products and add them to the orders array to pass them to the view
        for($i = 0; $i < count($orders); ++$i){
            $query = $pdo->prepare('SELECT product_name, unit_shortName, Product_SupplyOrder.quantity FROM Product_SupplyOrder INNER JOIN vStockableProduct ON vStockableProduct.id = idProduct WHERE idSupplyOrder = :idOrder');
            $query->execute([
                'idOrder' => $orders[$i]['id']
            ]);
            $linkedProducts = $query->fetchAll();
            $orders[$i]['linkedProducts'] = $linkedProducts;
        }

        return $this->render($response, 'Admin/SupplyOrders/index.html.twig', [
            'orders' => $orders
        ]);
    }

    /**
     * Display the supply order create view to be able to create a new supply order
     *
     * @param Request $request
     * @param Response $response
     * @return mixed
     */
    public function createAction(Request $request, Response $response) {
        // Fetch the pdo connection from the container dependency
        $pdo = $this->container->db;

        $query = $pdo->query("SELECT * FROM Supplier");
        $suppliers = $query->fetchAll();

        $query = $pdo->query("SELECT id, product_name, unit_name FROM vStockableProduct");
        $products = $query->fetchAll();

        return $this->render($response, 'Admin/SupplyOrders/create.html.twig', [
            'suppliers' => $suppliers,
            'products' => $products
        ]);
    }

    /**
     * Store a new supply order created by the user
     *
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function storeAction(Request $request, Response $response)
    {
        $supplierId = $request->getParam("supplierId");
        $tva = $request->getParam("tva");
        $productsId = $request->getParam("productsId");
        $prices = $request->getParam("prices");
        $quantities = $request->getParam("quantities");

        $error = false;

        // Check the required / NOT NULL fields
        if ($this->is_empty($supplierId)) {
            $error = true;
        }

        for($i = 0; $i < count($productsId); ++$i){
            if($this->is_empty($productsId[$i] || $this->is_empty($prices[$i]) || $this->is_empty($quantities[$i]))){
                $error = true;
                break;
            }
        }


        if(!$error){
            // Fetch the pdo connection from the container dependency
            $pdo = $this->container->db;

            try{
                // Start our transaction
                $pdo->beginTransaction();

                // Query 1: Insert the new Order
                $query = $pdo->prepare("INSERT INTO `Order`(orderAt, tva) VALUES(NOW(), :tva)");
                $query->execute([
                    ':tva' => $tva
                ]);
                $orderId = $pdo->lastInsertId();

                // Query2 : Insert the SupplyOrder
                $query = $pdo->prepare("INSERT INTO SupplyOrder(idOrder, idSupplier, idManager) VALUES(:idOrder, :idSupplier, :idManager)");
                $query->execute([
                    ':idOrder' => $orderId,
                    ':idSupplier' => $supplierId,
                    ':idManager' => $this->container->auth->user()['id']
                ]);

                // Query3 : Insert the Product_SupplyOrder
                for($i = 0; $i < count($productsId); ++$i){
                    $query = $pdo->prepare("INSERT INTO Product_SupplyOrder(idProduct, idSupplyOrder, price, quantity) VALUES(:idProduct, :idSupplyOrder, :price, :quantity)");
                    $query->execute([
                        ':idProduct' => $productsId[$i],
                        ':idSupplyOrder' => $orderId,
                        ':price' => $prices[$i],
                        ':quantity' => $quantities[$i]
                    ]);
                }

                // No exception has occured, so commit the changes.
                $pdo->commit();

            } catch (PDOException $exception) {
                //An exception has occured, which means that one of our database queries failed => Rollback
                $error = true;
                $pdo->rollback();
            }
        }

        // Error detected -> display flash message
        if($error){
            $this->container->flash->addMessage('error', 'Une erreur est survenue, veuillez vérifier vos données.');
            return $response->withRedirect($this->container->router->pathFor('admin_supply-orders_create'));
        }

        // No error
        $this->container->flash->addMessage('success', 'La commande fournisseur à bien été ajoutée.');
        return $response->withRedirect($this->container->router->pathFor('admin_supply-orders_index'));
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