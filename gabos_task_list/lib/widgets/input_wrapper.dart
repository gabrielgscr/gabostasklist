import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';


class InputWrapper extends StatelessWidget {
  final Widget? child;
  final Color? fillColor;
  final double padding;
  const InputWrapper({super.key, this.child, this.fillColor, this.padding = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: fillColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10.0), // Aquí
          border: Border.all(color: strongBlue, width: 2.0)
        ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: child,
      ),
    );
  }
}