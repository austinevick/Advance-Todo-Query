import 'package:flutter/material.dart';
import 'package:flutter_list_selection/widget/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/todo_provider.dart';
import 'tabs/all_todo.dart';
import '../../widget/todo_list.dart';

final searchtodoFutureProvider =
    StreamProvider.family((ref, String text) async* {
  final list = await ref.watch(todoProvider).getAllTodos();
  if (text.isEmpty) yield [];
  yield list
      .where((e) =>
          e.title!.toLowerCase().contains(text.toLowerCase()) ||
          e.note!.toLowerCase().contains(text.toLowerCase()))
      .toList();
});

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
          appBar: AppBar(
            title: CustomTextfield(
              controller: controller,
              hintText: 'Search note',
              autoFocus: true,
              onChanged: (value) => setState(() {}),
            ),
          ),
          body: ref.watch(todoFutureProvider).when(
              data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) => TodoList(todo: data[i])),
              error: (e, t) => const Center(),
              loading: () => const Center()));
    });
  }
}
