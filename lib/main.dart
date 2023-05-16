import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/utils.dart';
import 'provider/todo_provider.dart';
import 'view/home_view.dart';
import 'widget/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeView(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

final provider =
    FutureProvider((ref) => ref.watch(todoProvider).groupTodoByDate());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) => ref.watch(provider).when(
              data: (data) => Column(
                    children: [
                      ...data.entries.map((e) => Text(e.key.toString())),
                      const SizedBox(height: 10),
                      ...data.entries.map(
                        (e) => Expanded(
                            child: ListView.builder(
                                itemCount: e.value.length,
                                itemBuilder: (ctx, i) =>
                                    TodoList(todo: e.value[i]))),
                      ),
                    ],
                  ),
              error: (e, t) => const Center(),
              loading: () => const Center()),
        ),
      ),
    );
  }
}
