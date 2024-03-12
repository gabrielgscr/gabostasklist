import 'package:flutter/material.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/task_tile.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    required this.tasks,
    this.canScroll = true,
  });

  final List<Task> tasks;
  final bool canScroll;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: canScroll ? 
          const AlwaysScrollableScrollPhysics() : 
          const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
          );
        },
        separatorBuilder: (context, index) => Divider(
          thickness: 1.5,
          color: defaultColor,
        ),
        itemCount: tasks.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
      ),
    );
  }
}