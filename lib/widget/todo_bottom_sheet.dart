import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/todo.dart';
import '../provider/todo_provider.dart';
import '../view/tabs/all_todo.dart';
import '../view/tabs/completed_todo.dart';
import '../view/tabs/uncompleted_todo.dart';
import 'custom_button.dart';

class TodoBottomSheet extends StatefulWidget {
  final Todo todo;
  const TodoBottomSheet({super.key, required this.todo});

  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
  bool isCompleted = false;
  bool isArchive = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return SizedBox(
        height: 350,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.todo.title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1.8),
            const SizedBox(height: 40),
            const Spacer(),
            CustomButton(
              text: 'Move to archive',
              textColor: Colors.white,
              onPressed: () {
                if (widget.todo.isArchived!) {
                  setState(() => isArchive = false);
                } else {
                  setState(() => isArchive = true);
                }
                Todo updatedTodo = Todo(
                    title: widget.todo.title,
                    note: widget.todo.note,
                    alarmId: widget.todo.alarmId,
                    isArchived: isArchive,
                    isCompleted: widget.todo.isCompleted,
                    dateCreated: DateTime.now());
                updatedTodo.id = widget.todo.id;
                ref.read(todoProvider).updateTodo(updatedTodo);

                Navigator.of(context).pop(true);
              },
              color: Colors.black,
              width: 300,
              height: 45,
              radius: 50,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Delete',
              textColor: Colors.white,
              onPressed: () {
                ref.read(todoProvider).deleteTodo(widget.todo.id!);
                Navigator.of(context).pop(true);
              },
              color: Colors.black,
              width: 300,
              height: 45,
              radius: 50,
            ),
            const SizedBox(height: 20),
            CustomButton(
              width: 300,
              height: 45,
              radius: 50,
              color: Colors.black,
              text:
                  widget.todo.isCompleted! ? 'Mark as undone' : 'Mark as done',
              textColor: Colors.white,
              onPressed: () {
                if (widget.todo.isCompleted!) {
                  setState(() => isCompleted = false);
                } else {
                  setState(() => isCompleted = true);
                }
                Todo updatedTodo = Todo(
                    title: widget.todo.title,
                    note: widget.todo.note,
                    isArchived: false,
                    alarmId: widget.todo.alarmId,
                    isCompleted: isCompleted,
                    dateCreated: DateTime.now());
                updatedTodo.id = widget.todo.id;
                ref.read(todoProvider).updateTodo(updatedTodo);
                ref.invalidate(todoFutureProvider);
                ref.invalidate(completedTodoProvider);
                ref.invalidate(uncompletedTodoProvider);

                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }
}
