<?php

namespace App\Auth;

/**
 * This class manages the authentication.
 * It need access the container because in some method we need to communicate with the database.
 *
 * Class Auth
 * @package App\src\auth
 */
class Auth
{
    private $container;
    private $pdo;

    public function __construct($container)
    {
        $this->container = $container;
        $this->pdo = $this->container->db;
    }

    /**
     * Try to connect the user
     *
     * @param $email the email
     * @param $password The password
     * @return bool True if the user has been logged in, false otherwise
     */
    public function attempt($email, $password){
        $query = $this->pdo->prepare("SELECT * FROM vActiveStaff WHERE email = :email");
        $query->execute([':email' => $email]);
        $user = $query->fetch();

        // User exists and password match
        if($user != false && $user['password'] == $password){
            $_SESSION["user"] = $user['id'];
            return true;
        }else{
            return false;
        }
    }

    /**
     * Check if a user is already connected.
     *
     * @return bool True if the user is already connected, False otherwise
     */
    public function check(){
        return isset($_SESSION["user"]);
    }

    /**
     * Return an array with the connected user's data, null otherwise.
     *
     * @return array | null
     */
    public function user(){
        if($this->check()){
            $query = $this->pdo->prepare("SELECT * FROM Staff WHERE id = :id");
            $query->execute([':id' => $_SESSION["user"]]);
            return $query->fetch();
        }else{
            return null;
        }
    }

    /**
     * Sign out the connected user
     */
    public function logout(){
        unset($_SESSION['user']);
    }

    /**
     * Method which check if the current user has the asked role or not.
     * Possible role : waiter or manager
     *
     * @param $role The asked role
     * @return bool
     */
    public function hasRole($role){
        $hasAskedRole = false;
        $userId  = $this->user()['id'];

        // Check role only if a user is connected
        if(!empty($userId)) {
            if ($role == 'waiter') {
                $query = $this->pdo->query("SELECT COUNT(*) AS isWaiter FROM Waiter WHERE idStaff = ".$userId." AND active = 1");
                $hasAskedRole = $query->fetch()['isWaiter'] > 0;
            } else if ($role == 'manager') {
                $query = $this->pdo->query("SELECT COUNT(*) AS isManager FROM Manager WHERE idStaff = ".$userId." AND active = 1");
                $hasAskedRole = $query->fetch()['isManager'] > 0;
            }
        }

        return $hasAskedRole;
    }
}