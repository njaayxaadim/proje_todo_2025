import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart'; // ← AJOUTÉ
import '../models/task.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  TaskNotifier(this.ref) : super([]);

  Future<void> loadTasks() async {
    final user = ref.read(authProvider);
    if (user == null) return;
    final api = ref.read(apiProvider);
    try {
      final tasks = await api.getTasks(user.id);
      state = tasks;
    } catch (e) {
      print('Erreur loadTasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    state = [...state, task.copyWith(todoId: -1)];
    final api = ref.read(apiProvider);
    try {
      final res = await api.createTask(task);
      if (res['success'] == true) {
        final newId = res['todo_id'];
        state = state
            .map((t) => t.todoId == -1 ? t.copyWith(todoId: newId) : t)
            .toList();
      }
    } catch (e) {
      state = state.where((t) => t.todoId != -1).toList();
    }
  }

  Future<void> toggleDone(Task task) async {
    final updated = task.copyWith(done: !task.done);
    state = state.map((t) => t.todoId == task.todoId ? updated : t).toList();
    await ref.read(apiProvider).updateTask(updated);
  }

  Future<void> deleteTask(Task task) async {
    state = state.where((t) => t.todoId != task.todoId).toList();
    await ref.read(apiProvider).deleteTask(task.todoId!, task.accountId);
  }

  List<Task> getCompletedTasks() => state.where((t) => t.done).toList();
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final notifier = TaskNotifier(ref);
  WidgetsBinding.instance.addPostFrameCallback((_) => notifier.loadTasks());
  return notifier;
});
