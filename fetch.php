<?php
/*
 * Demonstrates PDOStatement::fetch()
 * fetch() returns ONE row per call (the next row of the result set),
 * or false when there are no more rows.
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// ---------- Example 1: fetch a single record by its ID ----------
// A prepared statement with a named placeholder (:id) is used because the value
// could come from the user (for example ?id=5 in the URL).
$id = isset($_GET['id']) ? (int) $_GET['id'] : 1;   // default to item 1

$stmt = $pdo->prepare("SELECT item_id, item_name, brand, unit_size, price_eur
                       FROM grocery_items
                       WHERE item_id = :id");
$stmt->execute(['id' => $id]);

// fetch() gets the first (and only) matching row
$item = $stmt->fetch();

echo '<h2>fetch() result: item with ID ' . $id . '</h2>';
echo '<pre>';
print_r($item);          // prints false-like empty output if the ID does not exist
echo '</pre>';

// ---------- Example 2: fetch() called repeatedly, one row at a time ----------
$stmt = $pdo->query("SELECT item_name, brand FROM grocery_items LIMIT 3");

echo '<h2>fetch() inside a while loop: first 3 rows</h2>';
echo '<pre>';
while ($row = $stmt->fetch()) {   // each call returns the next row until false
    print_r($row);
}
echo '</pre>';
