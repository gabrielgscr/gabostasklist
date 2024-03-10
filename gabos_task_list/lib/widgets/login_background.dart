import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/desktop.jpg'), context);
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              color: const Color.fromARGB(255, 196, 204, 208),
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          Widget widget = SizedBox(
          // color: Colors.red,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset('assets/desktop.jpg', fit: BoxFit.cover),
              ),
              child,
            ],
          ),
          );
          FlutterNativeSplash.remove();
          return widget;
        }
      },
    );
    
  }
}
