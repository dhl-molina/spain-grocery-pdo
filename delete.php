<?php
/*
 * Demonstrates deleting a record with a PDO prepared statement.
 * It removes the sample row added by insert.php (brand = 'Demo Brand').
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// Always include a WHERE clause, otherwise DELETE removes every row.
$sql = "DELETE FROM grocery_items
        WHERE item_name = :item_name
          AND brand = :brand";

$stmt = $pdo->prepare($sql);

// Run the DELETE with the values for the placeholders
$stmt->execute([
    'item_name' => 'Salsa Brava',
    'brand'     => 'Demo Brand',
]);

// rowCount() tells how many rows were actually deleted
$deleted = $stmt->rowCount();

if ($deleted > 0) {
    echo "Deleted $deleted record(s) from grocery_items.";
} else {
    echo 'Nothing to delete: no matching record found (run insert.php first).';
}
