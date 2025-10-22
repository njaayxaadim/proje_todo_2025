<?php
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $email = $data['email'];
    $password = password_hash($data['password'], PASSWORD_BCRYPT);  // Hash sécurisé

    $stmt = $pdo->prepare("INSERT INTO accounts_table (email, password) VALUES (?, ?)");
    if ($stmt->execute([$email, $password])) {
        echo json_encode(['success' => true, 'account_id' => $pdo->lastInsertId()]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Email déjà utilisé ou erreur']);
    }
}
?>