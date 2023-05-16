import 'package:flutter/material.dart';
import 'package:flutter_list_selection/widget/todo_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/selected_todo_provider.dart';
import '../provider/todo_provider.dart';
import 'tabs/all_todo.dart';

final archivedTodoProvider =
    FutureProvider((ref) => ref.watch(todoProvider).getArchivedTodos());

class ArchivedTodoView extends StatelessWidget {
  const ArchivedTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(selectedTodoProvider.notifier);
      final todos = ref.watch(selectedTodoProvider);
      return WillPopScope(
        onWillPop: () async {
          if (todos.isEmpty) {
            return Future.value(true);
          } else {
            notifier.clearSelectedTodos();
            return Future.value(false);
          }
        },
        child: Scaffold(
          appBar: todos.isEmpty
              ? AppBar(
                  title: const Text('Archived'),
                )
              : AppBar(
                  leading: IconButton(
                      onPressed: () => notifier.clearSelectedTodos(),
                      icon: const Icon(Icons.clear)),
                  title: Text("${todos.length}"),
                  actions: [
                    Tooltip(
                      message: 'Remove from archive',
                      child: IconButton(
                          iconSize: 25,
                          onPressed: () {
                            ref.read(todoProvider).updateTodos(todos, 1);

                            ref.invalidate(todoFutureProvider);
                            ref.invalidate(archivedTodoProvider);
                            notifier.clearSelectedTodos();
                          },
                          icon: const Icon(Icons.unarchive)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Tooltip(
                        message: 'Delete',
                        child: IconButton(
                            iconSize: 25,
                            onPressed: () => ref
                                    .read(todoProvider)
                                    .deleteTodos(todos)
                                    .whenComplete(() {
                                  ref.invalidate(todoFutureProvider);
                                  notifier.clearSelectedTodos();
                                }),
                            icon: const Icon(Icons.delete)),
                      ),
                    )
                  ],
                ),
          body: SafeArea(
              child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'These items stay archived when new items are added. Tap to change'),
              ),
              const Divider(thickness: 1.8),
              Expanded(
                child: ref.watch(archivedTodoProvider).when(
                    data: (data) => data.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.archive,
                                  size: 120, color: Colors.black54),
                              Text('Your archived notes will appear here')
                            ],
                          )
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (ctx, i) => TodoList(todo: data[i])),
                    error: (e, t) => const Center(),
                    loading: () => const Center()),
              ),
            ],
          )),
        ),
      );
    });
  }
}
