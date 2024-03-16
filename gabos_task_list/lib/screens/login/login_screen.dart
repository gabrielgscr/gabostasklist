import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/login_controller.dart';
import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/screens/login/register_screen.dart';
import 'package:gabos_task_list/screens/dashboard/welcome_screen.dart';
import 'package:gabos_task_list/tools/input_decorations.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:gabos_task_list/widgets/widgets.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Widget _newAccount() {
    return TextButton(
        onPressed: () => Get.off(const RegisterScreen()),
        style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
            shape: MaterialStateProperty.all(const StadiumBorder())),
        child: const Text(
          'Crear una nueva cuenta',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ));
  }

  Widget _loginForm(BuildContext context) {
    return CardContainer(
        child: Column(
      children: [
        const SizedBox(height: 10),
        Text('Ingresar', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 30),
        _LoginForm(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
        body: LoginBackground(
            child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 75,
            ),
            _loginForm(context),
            const SizedBox(height: 50),
            _newAccount(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget _loginButton() {
    final LoginController c = Get.find<LoginController>();
    final GlobalValuesController g = Get.find<GlobalValuesController>();
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: strongBlue,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            c.username.value = usernameController.text;
            c.password.value = passwordController.text;
            GenericResponse response = await c.login();
            Person? person = response.responseObject as Person?;
            if (response.responseCode == 1) {
              //showSnackbar(response.responseText);
              g.username = c.username.value;
              g.personId.value = person!.personId!;

              Get.off(const WelcomeScreen());
            } else {
              showSnackbar(response.responseText);
            }
          } else {
            showSnackbar(
                "Por favor, complete correctamente la información requerida");
          }
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              //loginForm.isLoading ? 'Espere' : 'Ingresar',
              'Ingresar',
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget _passwordField() {
    return TextFormField(
      controller: passwordController,
      autocorrect: false,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.defaultInputDecoration(
          hintText: '*****',
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline),
      //onChanged: (value) => loginForm.password = value,
      validator: (value) {
        return (value != null && value.length >= 6)
            ? null
            : 'La contraseña debe de ser de 6 caracteres';
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: usernameController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.defaultInputDecoration(
        hintText: 'name@domain.com',
        labelText: 'Correo electrónico',
        prefixIcon: Icons.alternate_email_rounded,
      ),
      //onChanged: (value) => loginForm.email = value,
      validator: (value) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no luce como un correo';
      },
    );
  }

  SwitchListTile _rememberMeCheck() {
    final LoginController c = Get.find<LoginController>();
    return SwitchListTile(
          title: const Text('Recuérdame'), 
          value: c.remember.value, 
          onChanged: (value) {
            c.remember.value = value;
          },
          activeColor: Colors.white,
        );
  }

  @override
  Widget build(BuildContext context) {
    LocalNotificationHelper.requestLocalNotificationPermission();
    return Obx(() => Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _emailField(),
          const SizedBox(height: 30),
          _passwordField(),
          const SizedBox(height: 30),
          //Remember me
          _rememberMeCheck(),
          const SizedBox(height: 30),
          _loginButton()
        ],
      ),
    ));
  }
}
