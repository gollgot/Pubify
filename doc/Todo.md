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

* Product
    * INSERT : N/A (DONE)
    * UPDATE : N/A (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* UnitMetric (DONE)
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* Stock
    * INSERT : Check if is a stockable product (DONE)
    * UPDATE : Check if is a stockable product (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* Ingredient 
    * INSERT : Check not Buyable (DONE)
    * UPDATE : Check not Buyable (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* Buyable
    * INSERT : Check not Ingredient, Start date before End (DONE)
    * UPDATE : Check not Ingredient, Start date before End (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* Drink
    * INSERT : Check not Food, alcohol level < 100 >= 0 (DONE)
    * UPDATE : Check not Food, alcohol level < 100 >= 0 (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* Food
    * INSERT : Check not Drink (DONE)
    * UPDATE : Check not Drink (DONE)
    * DELETE : NOT POSSIBLE (TODO)

* Food_Ingredient
    * INSERT : Food doesn't have a stock, quantity > 0 (DONE)
    * UPDATE : Food doesn't have a stock, quantity > 0 (DONE)
    * DELETE : Last ingredient can't be deleted (1..*) (TODO)

* HappyHour
    * INSERT : Manager is active, Start date greater than now, not overlapping w/ another HappyHour, Duration > 0, Reduction between 0 and 100 (TODO, manager is active)
    * UPDATE : Same as INSERT (TODO, manager is active)
    * DELETE : N/A (DONE)

* Drink_HappyHour
    * INSERT : Drink available during the whole happy hour! (DONE)
    * UPDATE : Drink available during the whole happy hour! (DONE)
    * DELETE : Last drink can't be deleted (1..*) (TODO)

* Product_SupplyOrder
    * INSERT : Product needs to have a stock, quantity can't be 0, update product stock (TODO, update product stock)
    * UPDATE : Product needs to have a stock, quantity can't be 0, update product stock (TODO, update product stock)
    * DELETE : Last order item (product) can't be deleted (1..*), update product stock (TODO)

* Buyable_CustomerOrder
    * INSERT : Quantity can't be 0, update buyables stock (ingredients if need be) (DONE)
    * UPDATE : Quantity can't be 0, update buyables stock (ingredients if need be) (TODO, update stock)
    * DELETE : Last order item (product) can't be deleted (1..*), update buyables stock (ingredients if need be) (TODO)

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