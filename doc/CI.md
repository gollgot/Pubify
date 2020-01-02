# Contraintes d'intégrité
* On ne peut pas supprimer le dernier Manager (DONE)
* On ne peut pas avoir des taux d'alcoolémie négatif (DONE)
* La durée (duration) d’une happy hour ne peut pas être négative (DONE).
* Le pourcentage de réduction d’une boisson d’une happy hour doit être supérieur à 0 et inférieur ou égal à 100 (DONE).
* Il ne peut pas y avoir deux happy hours qui se chevauchent (même période). (DONE)
* Un serveur ne peut pas prendre une commande client sur un produit qui est en quantité insuffisante (ou ingrédient qui le compose). (DONE, INSERT)
* On ne peut pas avoir en stock de la nourriture qui est composé d’ingrédients. (DONE)
* On ne peut pas commander chez un fournisseur de la nourriture qui est composée d’ingrédients. (DONE, INSERT)
* Un Staff ne peut plus rien faire s’il est supprimé. (DONE, A finaliser côté applicatif)
* Dans la table Buyable_CustomerOrder la quantité doit être supérieur à 0. (DONE)
* Dans la table Product_SupplyOrder la quantité doit être supérieur à 0. (DONE)
* Dans la la table Food_Ingredient la quantité doit être supérieur à 0. (DONE)
* La date de fin de vente doit être plus grande que la date de début. (DONE)
* Les produits d’un Happy Hour doivent être disponibles pour toute la durée de celle-ci. (DONE)
* Un Buyable peut être commandé par un client seulement s’il est disponible (i.e. date de commande entre date début et fin de vente).
