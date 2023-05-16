import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/todo_provider.dart';
import '../../widget/todo_list.dart';

final completedTodoProvider =
    FutureProvider((ref) => ref.watch(todoProvider).getCompletedTodos());

class CompletedTodos extends StatelessWidget {
  const CompletedTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref.watch(completedTodoProvider).when(
          data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, i) => TodoList(todo: data[i])),
          error: (e, t) => const Center(),
          loading: () => const Center()),
    );
  }
}
