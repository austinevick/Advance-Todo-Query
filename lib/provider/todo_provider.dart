import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_selection/common/utils.dart';
import 'package:flutter_list_selection/model/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/todo_db.dart';
import '../view/tabs/all_todo.dart';

final todoProvider = ChangeNotifierProvider((ref) => TodoProvider(ref));

class TodoProvider extends ChangeNotifier {
  final Ref ref;

  TodoProvider(this.ref);

  Future<List<Todo>> getAllTodos() async {
    final list = await TodoDatabaseRepository.getAllTodos();
    // list.groupListsBy((element) => null)
    // final r = list.groupBy((todo) => todo.dateCreated);

    return list.where((element) => element.isArchived == false).toList();
  }

  Future<Map<DateTime?, List<Todo>>> groupTodoByDate() async {
    final list = await TodoDatabaseRepository.getAllTodos();
    return list.groupListsBy((element) => element.dateCreated);
  }

  Future<List<Todo>> getCompletedTodos() async {
    final list = await getAllTodos();
    return list.where((element) => element.isCompleted == true).toList();
  }

  Future<List<Todo>> getUncompletedTodos() async {
    final list = await getAllTodos();
    return list.where((element) => element.isCompleted == false).toList();
  }

  Future<List<Todo>> getArchivedTodos() async {
    final list = await TodoDatabaseRepository.getAllTodos();
    return list.where((element) => element.isArchived == true).toList();
  }

  Future<int> saveTodo(Todo todo) async {
    return await TodoDatabaseRepository.saveTodo(todo);
  }

  Future<void> saveTodos(List<Todo> todo) async {
    return await TodoDatabaseRepository.saveTodos(todo);
  }

  Future<void> deleteTodos(List<Todo> selectedTodos) async {
    final ids = selectedTodos.map((e) => e.id).toList();
    await TodoDatabaseRepository.deleteTodos(ids);
    showSnackBar(
      "${selectedTodos.length} items deleted",
      onPressed: () async {
        await saveTodos(selectedTodos);
        ref.invalidate(todoFutureProvider);
      },
    );
  }

  Future<void> deleteTodo(int id) async {
    await TodoDatabaseRepository.deleteTodo(id);
    showSnackBar("Delete successful");
  }

  Future<int> updateTodo(Todo todo) async {
    return await TodoDatabaseRepository.updateTodo(todo);
  }

  Future<int> updateTodos(List<Todo> selectedTodos, int val) async {
    final id = selectedTodos.map((e) => e.id).toList();

    return await TodoDatabaseRepository.updateTodos(id, val);
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
