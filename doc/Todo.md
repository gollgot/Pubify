# TODO
* Créer procédure stockée
    * vérifier si valeur > 0 sur int (DONE)
    * valeur entre 2 bornes sur int (DONE)
* Créer des vues pour les héritages
* Créer les différents triggers (voir CI.md)
* Créer des after update et insert pour faire descendre/augmenter le stock
* Pour l'alcoholLevel dans drink, attention il peut pas etre > 100 (DONE)
* Créer un trigger after insert pour tous les produits (autre que nourriture composée) pour l'ajouter directement dans le stock à une quantité de 0
* Créer des triggers pour empécher l'execution de `DELETE` sur `Staff`, `Manager` et `Waiter` (DONE)
* /!\ Faire des triggers pour les héritages `{complete, disjoint}`
    * `Buyable`/`Ingredient` (DONE)
    * `Drink`/`Food` (DONE)
    * `CustomerOrder`/`SupplyOrder`