class Task {
  final int? todoId; // ← todo_id dans la BD
  final int accountId;
  final DateTime date;
  final String todo; // ← champ "todo" dans la BD
  final bool done;

  Task({
    this.todoId,
    required this.accountId,
    required this.date,
    required this.todo,
    this.done = false,
  });

  Task copyWith({
    int? todoId,
    int? accountId,
    DateTime? date,
    String? todo,
    bool? done,
  }) {
    return Task(
      todoId: todoId ?? this.todoId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      todo: todo ?? this.todo,
      done: done ?? this.done,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      todoId: json['todo_id'] as int?,
      accountId: json['account_id'] as int,
      date: DateTime.parse(json['date'] as String),
      todo: json['todo'] as String,
      done: (json['done'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        if (todoId != null) 'todo_id': todoId,
        'account_id': accountId,
        'date': date.toIso8601String().split('T')[0],
        'todo': todo,
        'done': done ? 1 : 0,
      };
}
