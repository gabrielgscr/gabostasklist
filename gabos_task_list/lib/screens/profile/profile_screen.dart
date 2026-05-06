import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/profile_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _getPersonInformation() {
    ProfileController controller = Get.find<ProfileController>();
    GlobalValuesController global = Get.find<GlobalValuesController>();
    return FutureBuilder(
      future: Future.wait([
        controller.getPersonInformation(global.personId.value),
        controller.rememberIsChecked(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Person person = snapshot.data![0];
            return ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Nombre'),
                  subtitle: Text(person.firstName!),
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: const Text('Apellido'),
                  subtitle: Text(person.lastName!),
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: const Text('Correo electrónico'),
                  subtitle: Text(
                    person.email!,
                  ), // Asegúrate de que tu clase Person tiene un campo de correo electrónico.
                  leading: const Icon(Icons.email),
                ),
                ListTile(
                  title: const Text('Fecha de creación'),
                  subtitle: Text(
                    '${person.createdDate!}',
                  ), // Asegúrate de que tu clase Person tiene un campo de fecha de creación.
                  leading: const Icon(Icons.date_range),
                ),
                _getRememberSwitchTile(),
                _getAutoLoginSwitchTile(),
              ],
            );
          }
        }
      },
    );
  }

  Widget _imageProfile() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/desktop.jpg',
              ), // Cambia esto a la ruta de tu imagen.
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Cambia esto a tu gusto.
              bottomRight: Radius.circular(20), // Cambia esto a tu gusto.
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Cambia esto a tu gusto.
                spreadRadius: 5, // Cambia esto a tu gusto.
                blurRadius: 7, // Cambia esto a tu gusto.
                offset: Offset(0, 5), // Cambia esto a tu gusto.
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: defaultPaddingSize * 2),
            child: Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(
                      image: AssetImage('assets/astronauta.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: TextButton(
                      onPressed: () {
                        showSnackbar(
                          'Pronto podrás cambiar tu foto de perfil',
                          type: AppSnackbarType.info,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Icon(Icons.camera_alt, color: strongBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getRememberSwitchTile() {
    ProfileController controller = Get.find<ProfileController>();
    return Obx(
      () => SwitchListTile(
        value: controller.remember.value,
        title: const Text('Recordar usuario'),
        subtitle: const Text('Mantén tu usuario guardado en la aplicación'),
        onChanged: (value) {
          controller.remember.value = value;
          controller.setRemember(value);
        },
      ),
    );
  }

  Widget _getAutoLoginSwitchTile() {
    ProfileController controller = Get.find<ProfileController>();
    return Obx(
      () => SwitchListTile(
        value: controller.remember.value,
        title: const Text('Auto login'),
        subtitle: const Text(
          'Inicia sesión automáticamente al abrir la aplicación',
        ),
        onChanged: (value) {
          controller.remember.value = value;
          controller.setRemember(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Column(
      children: [
        _imageProfile(),
        defaultVSpace,
        SingleChildScrollView(
          child: Padding(
            padding: defaultPadding,
            child: Column(children: [_getPersonInformation()]),
          ),
        ),
      ],
    );
  }
}
