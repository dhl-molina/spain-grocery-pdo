<?php
/*
 * Demonstrates updating an existing record with a PDO prepared statement.
 * It changes the price and stock of Cola Cao Cacao Soluble Original.
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// SET lists the columns to change; WHERE picks which row(s) are changed
$sql = "UPDATE grocery_items
        SET price_eur = :price_eur,
            stock_quantity = :stock_quantity
        WHERE item_name = :item_name
          AND brand = :brand";

$stmt = $pdo->prepare($sql);

$stmt->execute([
    'price_eur'      => 5.75,                    // new price in euros
    'stock_quantity' => 150,                     // new stock level
    'item_name'      => 'Cacao Soluble Original',
    'brand'          => 'Cola Cao',
]);

// rowCount() = number of rows whose values really changed
// (it is 0 if the new values are the same as the old ones)
echo 'Rows updated: ' . $stmt->rowCount() . '<br>';

// Read the record back to confirm the change
$check = $pdo->prepare("SELECT item_name, brand, price_eur, stock_quantity
                        FROM grocery_items
                        WHERE item_name = :item_name AND brand = :brand");
$check->execute(['item_name' => 'Cacao Soluble Original', 'brand' => 'Cola Cao']);

echo '<pre>';
print_r($check->fetch());
echo '</pre>';
