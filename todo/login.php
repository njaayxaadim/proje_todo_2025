<?php
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $email = $data['email'];
    $password = $data['password'];

    $stmt = $pdo->prepare("SELECT * FROM accounts_table WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {
        echo json_encode(['success' => true, 'account_id' => $user['account_id']]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Identifiants incorrects']);
    }
}
?>