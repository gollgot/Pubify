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
        $stmt = $this->pdo->prepare("SELECT * FROM Staff WHERE email = :email");
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch();

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
            $stmt = $this->pdo->prepare("SELECT * FROM Staff WHERE id = :id");
            $stmt->execute([':id' => $_SESSION["user"]]);
            return $stmt->fetch();
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
}