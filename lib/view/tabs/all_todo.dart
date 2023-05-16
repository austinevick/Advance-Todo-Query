import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/todo_provider.dart';
import '../../widget/todo_list.dart';

final todoFutureProvider =
    FutureProvider((ref) => ref.watch(todoProvider).getAllTodos());

class AllTodos extends StatelessWidget {
  const AllTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref.watch(todoFutureProvider).when(
          data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, i) => TodoList(todo: data[i])),
          error: (e, t) => const Center(),
          loading: () => const Center()),
    );
  }
}
