<?php
require 'config.php';               // <-- CORS + PDO

$method     = $_SERVER['REQUEST_METHOD'];
$account_id = $_GET['account_id'] ?? null;
$todo_id    = $_GET['todo_id']    ?? null;

if (!$account_id) {
    http_response_code(400);
    echo json_encode(['success'=>false,'message'=>'account_id requis']);
    exit;
}

try {
    // ---------- READ ----------
    if ($method === 'GET') {
        $stmt = $pdo->prepare("SELECT * FROM todo_tables WHERE account_id = ? ORDER BY date DESC");
        $stmt->execute([$account_id]);
        echo json_encode($stmt->fetchAll());
        exit;
    }

    // ---------- CREATE ----------
    if ($method === 'POST') {
        $input = file_get_contents('php://input');
        $data  = json_decode($input, true);

        if (!$data || !isset($data['date'],$data['todo'])) {
            http_response_code(400);
            echo json_encode(['success'=>false,'message'=>'date et todo requis']);
            exit;
        }

        $stmt = $pdo->prepare(
            "INSERT INTO todo_tables (account_id, date, todo, done) VALUES (?,?,?,?)"
        );
        $stmt->execute([
            $account_id,
            $data['date'],
            $data['todo'],
            $data['done'] ?? 0
        ]);

        echo json_encode(['success'=>true,'todo_id'=>$pdo->lastInsertId()]);
        exit;
    }

    // ---------- UPDATE ----------
    if ($method === 'PUT') {
        $input = file_get_contents('php://input');
        $data  = json_decode($input, true);

        if (!$data || !isset($data['todo_id'],$data['done'])) {
            http_response_code(400);
            echo json_encode(['success'=>false,'message'=>'todo_id et done requis']);
            exit;
        }

        $stmt = $pdo->prepare(
            "UPDATE todo_tables SET done = ? WHERE todo_id = ? AND account_id = ?"
        );
        $stmt->execute([$data['done'], $data['todo_id'], $account_id]);

        echo json_encode(['success'=>true]);
        exit;
    }

    // ---------- DELETE ----------
    if ($method === 'DELETE' && $todo_id) {
        $stmt = $pdo->prepare(
            "DELETE FROM todo_tables WHERE todo_id = ? AND account_id = ?"
        );
        $stmt->execute([$todo_id, $account_id]);

        echo json_encode(['success'=>true]);
        exit;
    }

    // Méthode non supportée
    http_response_code(405);
    echo json_encode(['success'=>false,'message'=>'Méthode non autorisée']);
} catch (Exception $e) {
    error_log('todos.php error: '.$e->getMessage());
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>'Erreur serveur']);
}
?>