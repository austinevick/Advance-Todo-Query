import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/utils.dart';
import '../model/todo.dart';
import '../view/add_todo_view.dart';

final selectedTodoProvider =
    StateNotifierProvider<SelectedTodoProvider, List<Todo>>(
        (ref) => SelectedTodoProvider());

class SelectedTodoProvider extends StateNotifier<List<Todo>> {
  SelectedTodoProvider() : super([]);

  void clearSelectedTodos() {
    state = [];
  }

  void selectTodoOnLongPressed(bool isSelected, Todo todo) {
    if (!isSelected) {
      state = [...state, todo];
    } else {
      state = [...state.where((element) => element != todo)];
    }
  }

  void selectTodoOnPressed(bool isSelected, Todo todo) {
    if (state.isEmpty) {
      push(AddTodoView(todo: todo));
    } else {
      if (!isSelected) {
        state = [...state, todo];
      } else {
        state = [...state.where((element) => element != todo)];
      }
    }
  }
}
