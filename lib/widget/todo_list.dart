import 'package:flutter/material.dart';
import 'package:flutter_list_selection/view/tabs/all_todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../provider/selected_todo_provider.dart';
import 'todo_bottom_sheet.dart';
import '../view/archived_todo_view.dart';
import '../view/tabs/completed_todo.dart';
import '../view/tabs/uncompleted_todo.dart';

class TodoList extends StatefulWidget {
  final Todo todo;

  const TodoList({super.key, required this.todo});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList>
    with SingleTickerProviderStateMixin {
  final controller = ScrollController();
  late final AnimationController animationController;
  late final Animation<Offset> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(5.0, 0.0))
        .animate(animationController);
    super.initState();
  }

  String dateFormatter(DateTime e) => DateFormat.yMMMd().format(e);

  Color textColor(bool isSelected) {
    if (isSelected) {
      return Colors.white;
    } else if (widget.todo.isCompleted!) {
      return Colors.grey;
    }
    return Colors.black;
  }

  Widget buildTrailingIcon(bool isSelected, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          if (widget.todo.isArchived!) return;

          final result = await showModalBottomSheet<bool>(
              context: context,
              builder: (context) => TodoBottomSheet(todo: widget.todo));
          if (result == null) return;
          Future.delayed(
              const Duration(seconds: 2), () => animationController.forward());
          Future.delayed(const Duration(seconds: 4), () {
            ref.invalidate(todoFutureProvider);
            ref.invalidate(completedTodoProvider);
            ref.invalidate(uncompletedTodoProvider);
            ref.invalidate(archivedTodoProvider);
          });
        },
        icon: isSelected
            ? const Icon(Icons.check_circle, color: Colors.white)
            : Icon(Icons.more_vert,
                color: widget.todo.isArchived!
                    ? Colors.transparent
                    : Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(selectedTodoProvider.notifier);
      final isSelected = ref.watch(selectedTodoProvider).contains(widget.todo);
      return SlideTransition(
        key: ValueKey(widget.todo.id),
        position: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
              onLongPress: () =>
                  notifier.selectTodoOnLongPressed(isSelected, widget.todo),
              onTap: () =>
                  notifier.selectTodoOnPressed(isSelected, widget.todo),
              selected: isSelected,
              title: Text(widget.todo.title!,
                  style: TextStyle(
                      color: textColor(isSelected),
                      fontWeight: FontWeight.w600)),
              selectedTileColor: Theme.of(context).primaryColor,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.note!,
                    maxLines: 3,
                    style: TextStyle(
                      color: textColor(isSelected),
                    ),
                  ),
                  Text(
                    dateFormatter(widget.todo.dateCreated!),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  )
                ],
              ),
              trailing: buildTrailingIcon(isSelected, ref)),
        ),
      );
    });
  }
}
