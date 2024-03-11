import 'package:flutter/material.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:intl/intl.dart';
class TaskDate extends StatelessWidget {
  const TaskDate({
    super.key,
    required this.task
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.calendar_today, color: isOverdue ? overDueTask : strongBlue),
          const SizedBox(width: 10.0,),
          Text(DateFormat(task.allDayTask! ? "dd/MM/yyyy" : "dd/MM/yyyy hh:mm").format(task.dueDate!),
            style: TextStyle(
              color: isOverdue ? overDueTask : strongBlue,
              fontSize: 16.0,
            )),
          Expanded(child: Container()),
        ],
      ),
    );
  }

    bool get isOverdue {
    if (task.isCompleted!) {
      return false;
    }
    return task.dueDate!.isBefore(DateTime.now());
  }
}