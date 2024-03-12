import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class NotesContainer extends StatelessWidget {
  const NotesContainer({super.key, required this.child, this.backgroundColor});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: Container(
        padding: defaultPadding,
        width: double.infinity,
        // Borde
        decoration: BoxDecoration(
          color: backgroundColor ?? notesColor,
          borderRadius: BorderRadius.circular(10), // Borde redondeado
        ),
        child: child,
      ),
    );
  }
}
