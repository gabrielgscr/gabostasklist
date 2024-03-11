import 'package:flutter/material.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/task_date.dart';
import 'package:gabos_task_list/widgets/theme.dart';


// Esta clase implementa un ListTile personalizado para mostrar una tarea.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: strongBlue,
          width: 1.0,
        ),
        borderRadius: defaultBorderRadius,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title ?? '', overflow: TextOverflow.ellipsis,),
            subtitle: Text(task.description ?? ''),
            isThreeLine: true,
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
    
              },
            ),
            leading: Icon(
              task.isCompleted! ? Icons.task : Icons.task_outlined,
              color: task.isCompleted! ? strongBlue : taskTodo,
            ),
            onTap: () {},
            // shape: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: strongBlue,
            //     width: 1.0,
            //   ),
            //   borderRadius: BorderRadius.circular(10.0),
            // )
          ),
          defaultVSpace,
          TaskDate(task: task),
          _space(),
        ],
      ),
    );
  }



  SizedBox _space() => const SizedBox(height: 10.0,);

}

