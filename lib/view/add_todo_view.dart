import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_selection/common/utils.dart';
import 'package:flutter_list_selection/model/todo.dart';
import 'package:flutter_list_selection/widget/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/todo_provider.dart';
import '../widget/custom_textfield.dart';

import 'tabs/all_todo.dart';
import 'tabs/uncompleted_todo.dart';

class AddTodoView extends StatefulWidget {
  final Todo? todo;
  const AddTodoView({super.key, this.todo});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  bool setAlarm = false;
  bool get isEmpty =>
      titleController.text.isEmpty || noteController.text.isEmpty;
  final alarmId = DateTime.now().millisecondsSinceEpoch % 100000;

  late TimeOfDay selectedTime;

  @override
  void initState() {
    if (widget.todo != null) {
      titleController.text = widget.todo!.title!;
      noteController.text = widget.todo!.note!;
    }
    selectedTime = TimeOfDay.now();
    super.initState();
  }

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
        id: alarmId,
        dateTime: dateTime,
        notificationTitle: titleController.text,
        notificationBody: noteController.text,
        assetAudioPath: "assets/mozart.mp3",
        stopOnNotificationOpen: false);
    return alarmSettings;
  }

  void saveAlarm() {
    Alarm.set(alarmSettings: buildAlarmSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
          actions: [
            IconButton(
                onPressed: () => setState(() => setAlarm = !setAlarm),
                icon: const Icon(Icons.alarm_add))
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CustomTextfield(
                      controller: titleController,
                      autoFocus: true,
                      hintText: 'Title'),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: noteController,
                    maxLines: null,
                    textStyle: TextStyle(),
                    hintText: 'Note',
                  ),
                  const SizedBox(height: 16),
                  setAlarm
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'This alarm is set for ${selectedTime.format(context)}'),
                            IconButton(
                                onPressed: () {
                                  Alarm.stop(int.parse(widget.todo!.alarmId!));
                                },
                                icon: const Icon(Icons.settings))
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  setAlarm
                      ? CustomButton(
                          color: Colors.black,
                          height: 45,
                          text: 'Set time',
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            setState(() {
                              selectedTime = pickedTime!;
                            });
                          },
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Todo todo = Todo(
                title: titleController.text,
                note: noteController.text,
                alarmId: alarmId.toString(),
                isCompleted: false,
                isArchived: false,
                dateCreated: DateTime.now());
            if (isEmpty) {
              showSnackBar('Please enter a value');
              return;
            }
            if (widget.todo == null) {
              ref.read(todoProvider).saveTodo(todo);
            } else {
              todo.id = widget.todo!.id;
              ref.read(todoProvider).updateTodo(todo);
            }
            if (setAlarm) {
              saveAlarm();
            }
            ref.invalidate(todoFutureProvider);
            ref.invalidate(uncompletedTodoProvider);
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.done),
        ),
      );
    });
  }
}
