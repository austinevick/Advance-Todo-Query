import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/todo_provider.dart';
import '../../widget/todo_list.dart';

final uncompletedTodoProvider =
    FutureProvider((ref) => ref.watch(todoProvider).getUncompletedTodos());

class UncompletedTodos extends StatelessWidget {
  const UncompletedTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref.watch(uncompletedTodoProvider).when(
          data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, i) => TodoList(todo: data[i])),
          error: (e, t) => const Center(),
          loading: () => const Center()),
    );
  }
}
