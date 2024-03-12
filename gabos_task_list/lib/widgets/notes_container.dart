import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class NotesContainer extends StatelessWidget {
  const NotesContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: Container(
        padding: defaultPadding,
        width: double.infinity,
        // Borde
        decoration: BoxDecoration(
          color: notesColor,
          borderRadius: BorderRadius.circular(10), // Borde redondeado
        ),
        child: child,
      ),
    );
  }
}
