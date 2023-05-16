import 'package:flutter/material.dart';
import 'package:flutter_list_selection/common/utils.dart';
import 'package:flutter_list_selection/view/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/selected_todo_provider.dart';
import '../provider/todo_provider.dart';
import 'archived_todo_view.dart';
import 'tabs/all_todo.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(selectedTodoProvider.notifier);
        final todos = ref.watch(selectedTodoProvider);
        return todos.isEmpty
            ? AppBar(
                title: Text(
                  'Note',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                actions: [
                  IconButton(
                      iconSize: 25,
                      onPressed: () => push(const SearchScreen()),
                      icon: const Icon(Icons.search)),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: PopupMenuButton<int>(
                      iconSize: 28,
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            push(const ArchivedTodoView());
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.archive),
                              Text('Archive'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : AppBar(
                leading: IconButton(
                    onPressed: () => notifier.clearSelectedTodos(),
                    icon: const Icon(Icons.clear)),
                title: Text("${todos.length}"),
                actions: [
                  IconButton(
                      iconSize: 25,
                      onPressed: () => ref
                              .read(todoProvider)
                              .updateTodos(todos, 0)
                              .whenComplete(() {
                            Future.delayed(const Duration(seconds: 2), () {
                              ref.invalidate(todoFutureProvider);
                              ref.invalidate(archivedTodoProvider);
                              notifier.clearSelectedTodos();
                            });
                          }),
                      icon: const Icon(Icons.archive)),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
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
                  )
                ],
              );
      },
    );
  }
}
