<?php
/*
 * Creates the PDO connection that every other file in this project
 * includes with:  require_once 'dbconfig.php';
 * After including it, the variable $pdo is ready to use.
 */

// --- Connection settings ---
$host    = 'localhost';       // database server
$db      = 'spain_grocery';   // database name created by grocery_spain.sql
$user    = 'root';            // MySQL username (XAMPP default)
$pass    = '';                // MySQL password (empty by default on XAMPP)
$charset = 'utf8mb4';         // supports accents such as á, é, ñ and the € sign

// --- Data Source Name (DSN): tells PDO which driver and database to use ---
$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

// --- PDO options ---
$options = [
    // Throw exceptions on SQL errors so we can catch them with try/catch
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    // fetch() and fetchAll() return associative arrays (column name => value)
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    // Use real prepared statements (safer against SQL injection)
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    // Create the connection object
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    // Stop the script with a readable message if the connection fails
    exit('Database connection failed: ' . $e->getMessage());
}
