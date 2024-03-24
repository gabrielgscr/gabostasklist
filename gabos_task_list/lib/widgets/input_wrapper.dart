import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';


class InputWrapper extends StatelessWidget {
  final Widget? child;
  const InputWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0), // Aquí
          border: Border.all(color: strongBlue, width: 2.0)
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: child,
      ),
    );
  }
}