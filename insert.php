<?php
/*
 * Demonstrates inserting a new record with a PDO prepared statement.
 * Note: every time this page is loaded, one more row is added.
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// SQL with named placeholders: values are sent separately, never glued into the string
$sql = "INSERT INTO grocery_items
            (item_name, brand, category_id, unit_size, price_eur, stock_quantity, expiry_date, is_alcoholic)
        VALUES
            (:item_name, :brand, :category_id, :unit_size, :price_eur, :stock_quantity, :expiry_date, :is_alcoholic)";

// Prepare the statement once
$stmt = $pdo->prepare($sql);

// The new record (category 4 = Oils, Sauces & Condiments)
$newItem = [
    'item_name'      => 'Salsa Brava',
    'brand'          => 'Demo Brand',
    'category_id'    => 4,
    'unit_size'      => '250 g',
    'price_eur'      => 1.95,
    'stock_quantity' => 50,
    'expiry_date'    => '2027-12-31',
    'is_alcoholic'   => 0,
];

// Run the INSERT with the values
$stmt->execute($newItem);

// lastInsertId() returns the AUTO_INCREMENT item_id of the row just added
echo 'New item inserted! item_id = ' . $pdo->lastInsertId() . '<br>';
echo 'Rows affected: ' . $stmt->rowCount();
