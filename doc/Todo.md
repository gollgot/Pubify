# TODO
/!\ Clean up trigger file (regroup triggers, etc... and put BIG TITLE COMMENTS) /!\
* Create procedure for errors who takes a message as param (DONE)

## Triggers
* Staff (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : NOT POSSIBLE
    
* WAITER/MANAGER (DONE)
    * INSERT : N/A 
    * UPDATE : Can't delete the last manager 
    * DELETE : NOT POSSIBLE

* Order (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* CustomerOrder/SupplyOrder (DONE)
    * INSERT : Check not SupplyOrder/CustomerOrder and waiter/manager is active
    * UPDATE : Check not SupplyOrder/CustomerOrder and waiter/manager is active
    * DELETE : Delete order entry

* Supplier (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* Product (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : NOT POSSIBLE

* UnitMetric (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* Stock (DONE)
    * INSERT : Check if is a stockable product
    * UPDATE : Check if is a stockable product
    * DELETE : NOT POSSIBLE

* Ingredient (DONE)
    * INSERT : Check not Buyable
    * UPDATE : Check not Buyable
    * DELETE : NOT POSSIBLE

* Buyable (DONE)
    * INSERT : Check not Ingredient, Start date before End
    * UPDATE : Check not Ingredient, Start date before End
    * DELETE : NOT POSSIBLE

* Drink (DONE)
    * INSERT : Check not Food, alcohol level < 100 >= 0
    * UPDATE : Check not Food, alcohol level < 100 >= 0
    * DELETE : NOT POSSIBLE

* Food (DONE)
    * INSERT : Check not Drink
    * UPDATE : Check not Drink
    * DELETE : NOT POSSIBLE

* Food_Ingredient (DONE)
    * INSERT : Food doesn't have a stock, quantity > 0
    * UPDATE : Food doesn't have a stock, quantity > 0
    * DELETE : Last ingredient can't be deleted (1..*)

* HappyHour (DONE)
    * INSERT : Manager is active, Start date greater than now, not overlapping w/ another HappyHour, Duration > 0, Reduction between 0 and 100
    * UPDATE : Same as INSERT
    * DELETE : N/A

* Drink_HappyHour (DONE)
    * INSERT : Drink available during the whole happy hour!
    * UPDATE : Drink available during the whole happy hour!
    * DELETE : Last drink can't be deleted (1..*)

* Product_SupplyOrder (DONE)
    * INSERT : Product needs to have a stock, quantity can't be 0, update product stock
    * UPDATE : Product needs to have a stock, quantity can't be 0, update product stock
    * DELETE : Last order item (product) can't be deleted (1..*), update product stock

* Buyable_CustomerOrder
    * INSERT : Quantity can't be 0, update buyables stock (ingredients if need be) (DONE)
    * UPDATE : Quantity can't be 0, update buyables stock (ingredients if need be) (TODO, verif new stock quantity, update stock)
    * DELETE : Last order item (product) can't be deleted (1..*), update buyables stock (ingredients if need be) (TODO, update stock)


## APPLICATION
* Voir (index) / ajouter (create / store) pour les commandes fournisseurs
* Finir le store des happyhours (in progress)
* Pas oublié de mettre le stock a 0 coté app quand on créér un produits non composé

### Améliorations
* bouger $this->container->pdo dans le constructeur de la classe controller plutôt que de le taper a chaque methode de chaque controller

### Bugs
* N/A