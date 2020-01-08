# TODO
/!\ Clean up trigger file (regroup triggers, etc... and put BIG TITLE COMMENTS) /!\
* Create procedure for errors who takes a message as param

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

* CustomerOrder/SupplyOrder
    * INSERT : Check not SupplyOrder/CustomerOrder and waiter/manager is active (DONE)
    * UPDATE : Check not SupplyOrder/CustomerOrder and waiter/manager is active (DONE)
    * DELETE : Delete order entry (TODO)

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

* HappyHour (TODO)
    * INSERT : Manager is active, Start date greater than now, not overlapping w/ another HappyHour, Duration > 0, Reduction between 0 and 100 (TODO, manager is active)
    * UPDATE : Same as INSERT (TODO, manager is active)
    * DELETE : N/A (DONE)

* Drink_HappyHour (DONE)
    * INSERT : Drink available during the whole happy hour!
    * UPDATE : Drink available during the whole happy hour!
    * DELETE : Last drink can't be deleted (1..*)

* Product_SupplyOrder
    * INSERT : Product needs to have a stock, quantity can't be 0, update product stock (TODO, update product stock)
    * UPDATE : Product needs to have a stock, quantity can't be 0, update product stock (TODO, update product stock)
    * DELETE : Last order item (product) can't be deleted (1..*), update product stock (TODO, update product stock)

* Buyable_CustomerOrder
    * INSERT : Quantity can't be 0, update buyables stock (ingredients if need be) (DONE)
    * UPDATE : Quantity can't be 0, update buyables stock (ingredients if need be) (TODO, update stock)
    * DELETE : Last order item (product) can't be deleted (1..*), update buyables stock (ingredients if need be) (TODO, update stock)

## Heritage procedures
* create/update_waiter(..)
* create/update_manager(..)
* create/update_customer_order(..)
* create/update_supply_order(..)
* create/update_drink(..)
* create/update_stockable_food(..)
    * creates new empty stock
* create/update_nonstockable_food(..)
* create/update_ingredient(..)
* create/update_buyable(..)