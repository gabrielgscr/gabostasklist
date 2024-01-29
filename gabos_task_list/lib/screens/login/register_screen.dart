import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/register_controller.dart';
import 'package:gabos_task_list/screens/login/login_screen.dart';
import 'package:gabos_task_list/tools/input_decoratios.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:gabos_task_list/widgets/widgets.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterController c = Get.put(RegisterController());
    return Scaffold(
      body: LoginBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.off(const LoginScreen()),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      Text('Crear cuenta',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _RegisterForm(),
                ],
              )),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () => Get.off(const LoginScreen()),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  )),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        //key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            _nameBox(),
            const SizedBox(height: 30),
            _lastNameBox(),
            const SizedBox(height: 30),
            _emailBox(),
            const SizedBox(height: 30),
            passwordBox(),
            const SizedBox(height: 30),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    final RegisterController c = Get.find<RegisterController>();
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.deepPurple,
        onPressed: c.loading.value
            ? null
            : () async {
                c.loading.value = true;
                await c.createUser();
                c.loading.value = false;
                showSnackbar("Usuario creado correctamente");
                Get.off(const LoginScreen());
              },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'Registrarse',
              //loginForm.isLoading ? 'Espere' : 'Ingresar',
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget _nameBox() {
    final RegisterController c = Get.find<RegisterController>();
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Nombre',
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline),
      onChanged: (value) => c.name = value,
      validator: (value) {
        return (value != null && value.length >= 2)
            ? null
            : 'El valor ingresado no luce como un nombre';
      },
    );
  }

  Widget _lastNameBox() {
    final RegisterController c = Get.find<RegisterController>();
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Apellido',
          labelText: 'Apellido',
          prefixIcon: Icons.person_outline),
      onChanged: (value) => c.lastname = value,
      validator: (value) {
        return (value != null && value.length >= 2)
            ? null
            : 'El valor ingresado no luce como un apellido';
      },
    );
  }

  Widget passwordBox() {
    final RegisterController c = Get.find<RegisterController>();
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
          hintText: '*****',
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline),
      onChanged: (value) {
        c.password = value;
        c.passwordConfirm = value;
      },
      validator: (value) {
        return (value != null && value.length >= 6)
            ? null
            : 'La contraseña debe de ser de 6 caracteres';
      },
    );
  }

  Widget _emailBox() {
    final RegisterController c = Get.find<RegisterController>();
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
          hintText: 'name@domain.com',
          labelText: 'Correo electrónico',
          prefixIcon: Icons.alternate_email_rounded),
      onChanged: (value) => c.email = value,
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
}
