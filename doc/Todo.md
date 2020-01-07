# TODO
/!\ Clean up trigger file (regroup triggers, etc... and put BIG TITLE COMMENTS) /!\

## Triggers
* Staff
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : NOT POSSIBLE
* WAITER/MANAGER
    * INSERT : N/A
    * UPDATE : Edit staff entry
    * DELETE : NOT POSSIBLE

* Order
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* CustomerOrder/SupplyOrder
    * INSERT : Check not SupplyOrder/CustomerOrder
    * UPDATE : Check not SupplyOrder/CustomerOrder
    * DELETE : Delete order entry

* Supplier
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* Product
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : NOT POSSIBLE

* UnitMetric
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : N/A

* Stock
    * INSERT : N/A
    * UPDATE : N/A
    * DELETE : NOT POSSIBLE

* Ingredient
    * INSERT : Check not Buyable,
    * UPDATE : Check not Buyable
    * DELETE : NOT POSSIBLE

* Buyable
    * INSERT : Check not Ingredient, Start date before End
    * UPDATE : Check not Ingredient, Start date before End (If they changed)
    * DELETE : NOT POSSIBLE

* Drink
    * INSERT : Check not Food, alcohol level < 100 >= 0
    * UPDATE : Check not Food, alcohol level < 100 >= 0
    * DELETE : NOT POSSIBLE

* Food
    * INSERT : Check not Drink
    * UPDATE : Check not Drink
    * DELETE : NOT POSSIBLE

* Food_Ingredient
    * INSERT : Food doesn't have a stock, quantity > 0
    * UPDATE : Food doesn't have a stock, quantity > 0
    * DELETE : Last ingredient can't be deleted (1..*)

* HappyHour
    * INSERT : Manager is active, Start date greater than now, not overlapping w/ another HappyHour, Duration > 0, Reduction between 0 and 100
    * UPDATE : Same as INSERT
    * DELETE : N/A

* Drink_HappyHour
    * INSERT : Drink available during the whole happy hour!
    * UPDATE : Drink available during the whole happy hour!
    * DELETE : Last drink can't be deleted (1..*)

* Product_SupplyOrder
    * INSERT : Product needs to have a stock, quantity can't be 0, update product stock
    * UPDATE : Product needs to have a stock, quantity can't be 0, update product stock
    * DELETE : Last order item (product) can't be deleted (1..*), update product stock

* Buyable_CustomerOrder
    * INSERT : Quantity can't be 0, update buyables stock (ingredients if need be)
    * UPDATE : Quantity can't be 0, update buyables stock (ingredients if need be)
    * DELETE : Last order item (product) can't be deleted (1..*), update buyables stock (ingredients if need be)

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