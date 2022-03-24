import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

import '../data/local_storage.dart';
import '../main.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    //Araöa kısmının sağ tarafındaki iconları
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //En başdaki iconlar
    return GestureDetector(
        onTap: () {
          close(
              context, null); //null olan kısım: Bizi açan sayfaya veri döndürme
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.red,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    //Arama yapıp ara butonuna tıkladıktan sonra gelecek sonuçlar
    List<Task> filteredList = allTasks
        .where((mission) =>
            mission.name.toLowerCase().contains(query.toLowerCase()))
        .toList(); //Aranan kelimeyi filtreledik
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var _currentTask = filteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('remove_task').tr(),
                  ],
                ),
                key: Key(_currentTask.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: _currentTask);
                },
                child: TaskItem(
                  task: _currentTask,
                ),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Hata olduğu zaman gösterilecek yapı
    return Container();
  }
}
