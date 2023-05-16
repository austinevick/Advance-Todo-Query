import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo.dart';

class TodoDatabaseRepository {
  static Database? _db;
  static const String TABLE = 'todoTable';
  static const String DB_NAME = 'todo1.db';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String NOTE = 'note';
  static const String ISARCHIVED = 'isArchived';
  static const String ALARMID = 'alarmId';
  static const String ISCOMPLETED = 'isCompleted';
  static const String DATECREATED = 'dateCreated';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initializeDatabase();
    return _db!;
  }

  static Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static _createDatabase(Database db, int version) async {
    await db
        .execute('''CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $TITLE TEXT, $DATECREATED TEXT, $ALARMID TEXT, 
        $NOTE TEXT, $ISCOMPLETED BOOLEAN, $ISARCHIVED BOOLEAN)''');
  }

  static Future<int> saveTodo(Todo todo) async {
    var dbClient = await database;
    return await dbClient.insert(TABLE, todo.toMap());
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    var dbClient = await database;
    for (var todo in todos) {
      dbClient.insert(TABLE, todo.toMap());
    }
  }

  static Future<List<Todo>> getAllTodos() async {
    var dbClient = await database;
    final todos = await dbClient.query(TABLE,
        columns: [
          ID,
          TITLE,
          NOTE,
          ISCOMPLETED,
          ISARCHIVED,
          ALARMID,
          DATECREATED
        ],
        groupBy: DATECREATED,
        orderBy: DATECREATED);
    return todos.map((e) => Todo.fromMap(e)).toList();
  }

  static Future<List<Todo>> getSpecificTodo(String where) async {
    var dbClient = await database;
    final todos = await dbClient.query(TABLE,
        columns: [
          ID,
          TITLE,
          NOTE,
          ISCOMPLETED,
          ISARCHIVED,
          ALARMID,
          DATECREATED
        ],
        groupBy: DATECREATED,
        where: where,
        orderBy: DATECREATED);

    return todos.map((e) => Todo.fromMap(e)).toList();
  }

  static Future<int> deleteTodo(int id) async {
    var dbClient = await database;
    return dbClient.delete(
      TABLE,
      where: '$ID = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteTodos(List<int?> id) async {
    var dbClient = await database;
    return dbClient.delete(
      TABLE,
      where: '$ID IN (${List.filled(id.length, '?').join(',')})',
      whereArgs: id,
    );
  }

  static Future<int> deleteAllTodo() async {
    var dbClient = await database;
    return dbClient.delete(TABLE);
  }

  static Future<int> updateTodos(List<int?> ids, int val) async {
    var dbClient = await database;
    return dbClient.rawUpdate(
        'UPDATE $TABLE SET $ISARCHIVED = $val WHERE $ID IN (${List.filled(ids.length, '?').join(',')})',
        ids);
  }

  static Future<int> updateTodo(Todo todo) async {
    var dbClient = await database;
    return dbClient
        .update(TABLE, todo.toMap(), where: '$ID = ?', whereArgs: [todo.id]);
  }
}
