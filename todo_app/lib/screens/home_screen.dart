// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/task.dart' show Task;
import 'dart:io';

import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/weather_provider.dart';
import 'login_screen.dart';

// --- NOUVEAU PROVIDER POUR LA RECHERCHE ---
final searchQueryProvider = StateProvider<String>((ref) => '');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final photoPath = ref.watch(profileProvider);
    final weather = ref.watch(weatherProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Filtrer les tâches
    final filteredTasks = tasks.where((task) {
      return task.todo.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // === PHOTO DE PROFIL ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => ref.read(profileProvider.notifier).pickPhoto(),
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    photoPath != null && File(photoPath).existsSync()
                        ? FileImage(File(photoPath))
                        : null,
                child: photoPath == null || !File(photoPath).existsSync()
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
          ),

          // === MÉTÉO ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: weather.when(
              data: (temp) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(temp,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              loading: () => const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator()),
              error: (_, __) => const Text('Météo indisponible',
                  style: TextStyle(color: Colors.red)),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                labelText: 'Rechercher une tâche',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // === LISTE DES TÂCHES ===
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text('Aucune tâche trouvée',
                        style: TextStyle(fontSize: 16, color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            task.todo,
                            style: TextStyle(
                              decoration:
                                  task.done ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(_formatDate(task.date),
                              style: const TextStyle(fontSize: 12)),
                          trailing: Checkbox(
                            value: task.done,
                            onChanged: (_) => ref
                                .read(taskProvider.notifier)
                                .toggleDone(task),
                          ),
                          onLongPress: () =>
                              _showEditDialog(context, ref, task),
                        ),
                      );
                    },
                  ),
          ),

          // === BOUTONS D'ACTION ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final completed =
                          ref.read(taskProvider.notifier).getCompletedTasks();
                      _showCompletedDialog(context, completed);
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Historique'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouvelle tâche'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(_formatDate(selectedDate)),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) selectedDate = date;
                  },
                  child: const Text('Changer'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final user = ref.read(authProvider);
              if (user != null && descController.text.trim().isNotEmpty) {
                final newTask = Task(
                  accountId: user.id,
                  date: selectedDate,
                  todo: descController.text.trim(),
                );
                ref.read(taskProvider.notifier).addTask(newTask);
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Task task) {
    final descController = TextEditingController(text: task.todo);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier la tâche'),
        content: TextField(
          controller: descController,
          decoration: const InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              final updatedTask =
                  task.copyWith(todo: descController.text.trim());
              ref.read(taskProvider.notifier).toggleDone(updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Modifier'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showCompletedDialog(BuildContext context, List<Task> completed) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Tâches accomplies (${completed.length})'),
        content: completed.isEmpty
            ? const Text('Aucune tâche terminée')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: completed.length,
                  itemBuilder: (context, index) {
                    final task = completed[index];
                    return ListTile(
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(task.todo),
                      subtitle: Text(_formatDate(task.date)),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'))
        ],
      ),
    );
  }
}
