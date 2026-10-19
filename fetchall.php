<?php
/*
 * Demonstrates PDOStatement::fetchAll()
 * fetchAll() returns EVERY row of the result set as an array of arrays.
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// Write the SQL query (no user input here, so query() is safe)
$sql = "SELECT item_id, item_name, brand, price_eur
        FROM grocery_items
        ORDER BY item_id
        LIMIT 5";

// Run the query and get a PDOStatement object
$stmt = $pdo->query($sql);

// fetchAll() pulls all rows at once into a single array
$items = $stmt->fetchAll();

// <pre> keeps the line breaks and indentation of print_r() readable in the browser
echo '<h2>fetchAll() result: first 5 grocery items</h2>';
echo '<pre>';
print_r($items);
echo '</pre>';

// rows returned
echo 'Number of rows returned: ' . count($items);
