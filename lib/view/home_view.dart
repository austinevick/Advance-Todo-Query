import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_selection/view/add_todo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/utils.dart';
import '../provider/selected_todo_provider.dart';
import 'alarm_screen.dart';
import 'custom_appbar.dart';
import 'tabs/all_todo.dart';
import 'tabs/completed_todo.dart';
import 'tabs/uncompleted_todo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription ??= Alarm.ringStream.stream
        .listen((alarm) => push(AlarmScreen(id: alarm.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(selectedTodoProvider.notifier);
      final todos = ref.watch(selectedTodoProvider);
      return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: () async {
            if (todos.isEmpty) {
              return Future.value(true);
            } else {
              notifier.clearSelectedTodos();
              return Future.value(false);
            }
          },
          child: Scaffold(
            appBar: const PreferredSize(
                preferredSize: Size(60, 60), child: CustomAppBar()),
            body: const Column(
              children: [
                TabBar(tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Uncompleted'),
                ]),
                Expanded(
                  child: TabBarView(children: [
                    AllTodos(),
                    CompletedTodos(),
                    UncompletedTodos()
                  ]),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => push(const AddTodoView()),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
    });
  }
}
