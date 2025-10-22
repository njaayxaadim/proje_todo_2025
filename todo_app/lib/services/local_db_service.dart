// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/task.dart';
// import '../models/task.dart';
// import '../services/api_service.dart';


// class LocalDbService {
//   static Database? _db;

//   Future<Database> get db async {
//     if (_db != null) return _db!;
//     _db = await _initDb();
//     return _db!;
//   }

//   Future<Database> _initDb() async {
//     String path = join(await getDatabasesPath(), 'todo_local.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDb,
//     );
//   }

//   Future _createDb(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE tasks (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         account_id INTEGER NOT NULL,
//         date TEXT NOT NULL,
//         description TEXT NOT NULL,
//         done INTEGER DEFAULT 0,
//         is_synced INTEGER DEFAULT 0
//       )
//     ''');
//   }

//   Future<void> insertTask(Task task, int accountId) async {
//     final dbClient = await db;
//     await dbClient.insert('tasks', {
//       'account_id': accountId,
//       'date': task.date.toIso8601String(),
//       'description': task.description,
//       'done': task.done ? 1 : 0,
//       'is_synced': 0,
//     });
//   }

//   Future<List<Task>> getLocalTasks(int accountId) async {
//     final dbClient = await db;
//     final List<Map<String, dynamic>> maps = await dbClient.query(
//       'tasks',
//       where: 'account_id = ?',
//       whereArgs: [accountId],
//     );
    
//     return List.generate(maps.length, (i) {
//       return Task(
//         id: maps[i]['id'] as int?,
//         accountId: accountId,
//         date: DateTime.parse(maps[i]['date'] as String),
//         description: maps[i]['description'] as String,
//         done: (maps[i]['done'] as int) == 1,
//       );
//     });
//   }

//   Future<void> updateLocalTask(Task task) async {
//     final dbClient = await db;
//     await dbClient.update(
//       'tasks',
//       {
//         'description': task.description,
//         'done': task.done ? 1 : 0,
//         'is_synced': 0,
//       },
//       where: 'id = ?',
//       whereArgs: [task.id],
//     );
//   }

//   Future<void> deleteLocalTask(int id) async {
//     final dbClient = await db;
//     await dbClient.delete(
//       'tasks',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> markAsSynced(int id) async {
//     final dbClient = await db;
//     await dbClient.update(
//       'tasks',
//       {'is_synced': 1},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> syncTasks(int accountId, ApiService api) async {
//     // TODO: Implémenter la synchronisation complète
//     final localTasks = await getLocalTasks(accountId);
//     // Pour l'instant, juste récupérer du serveur
//     try {
//       final serverTasks = await api.getTasks(accountId);
//       // Mettre à jour local avec server
//       await _updateLocalFromServer(accountId, serverTasks);
//     } catch (e) {
//       print('Sync failed: $e');
//     }
//   }

//   Future<void> _updateLocalFromServer(int accountId, List<Task> serverTasks) async {
//     final dbClient = await db;
//     await dbClient.delete('tasks', where: 'account_id = ?', whereArgs: [accountId]);
    
//     for (var task in serverTasks) {
//       await dbClient.insert('tasks', {
//         'id': task.id ?? 0,
//         'account_id': accountId,
//         'date': task.date.toIso8601String(),
//         'description': task.description,
//         'done': task.done ? 1 : 0,
//         'is_synced': 1,
//       });
//     }
//   }
// }