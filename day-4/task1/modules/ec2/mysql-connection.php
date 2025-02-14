<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = getenv("DB_HOST");
$username = getenv("DB_USER");
$password = getenv("DB_PASS");
$dbname = getenv("DB_NAME");
$port = 3306;

try {
    $dsn = "mysql:host=$servername;dbname=$dbname;port=$port;charset=latin1";
    $pdo = new PDO($dsn, $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES latin1 COLLATE latin1_swedish_ci"
    ]);

    echo "✅ Successfully connected to MySQL!";
} catch (PDOException $e) {
    die("❌ ERROR: Connection failed - " . $e->getMessage());
}
?>