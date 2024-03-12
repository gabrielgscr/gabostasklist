import 'package:flutter/material.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/notes_container.dart';
import 'package:gabos_task_list/widgets/task_list_view.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class TaskPanelList extends StatelessWidget {

 const TaskPanelList({
    super.key,  
    required this.getTasks,
    required this.swapFunction,
    required this.isExpanded,
    required this.title,
    this.noDataTitle = "No hay tareas",
    this.backgroundColor,
    required this.getTasksParameter,
  });

  final Future<List<Task>> Function(int) getTasks;
  final void Function() swapFunction;
  final bool isExpanded;
  final String title;
  final String noDataTitle;
  final Color? backgroundColor;
  final int getTasksParameter;

  @override
  Widget build(BuildContext context) {
    return NotesContainer(
      backgroundColor: backgroundColor,
      child: ExpansionPanelList(

        expansionCallback: (int index, bool isExpanded) {
          swapFunction();
        },
        children: [
          ExpansionPanel(
            backgroundColor: backgroundColor ?? notesColor,
            headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(title),
                );
              }, 
            body: FutureBuilder(
              future: getTasks(getTasksParameter),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Padding(
                    padding: defaultPadding,
                    child: Center(child: Text(noDataTitle)),
                  );
                } else {
                  List<Task> tasks = snapshot.data!;
                  return TaskListView(tasks: tasks, canScroll: false);
                }
              },
            ),
            isExpanded: isExpanded,
          ),
        ],
      ),
    );
  }
}