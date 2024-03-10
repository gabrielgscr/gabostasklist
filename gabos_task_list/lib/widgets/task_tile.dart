import 'package:flutter/material.dart';


// Esta clase implementa un ListTile personalizado para mostrar una tarea.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.title, this.description = '', 
  this.isCompleted = false, this.dueDate});

  final String? description;
  final DateTime? dueDate;
  final bool? isCompleted;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description ?? '', overflow: TextOverflow.ellipsis,),
      isThreeLine: true,
      trailing: Checkbox(
        value: isCompleted,
        onChanged: (value) {},
      ),
      onTap: () {},
      shape: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      )
    );
  }
}