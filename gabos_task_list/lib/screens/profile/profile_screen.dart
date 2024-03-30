import 'package:flutter/material.dart';
import 'package:gabos_task_list/widgets/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: defaultPadding,
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100), 
                  child: const Image(image: AssetImage('astronauta.png')
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}