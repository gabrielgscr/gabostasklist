import 'dart:io';

import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/profile_image_store.dart';
import 'package:gabos_task_list/tools/shared_preferences_helper.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var editMode = false.obs;
  var remember = false.obs;
  final currentPerson = Rxn<Person>();
  final profileImagePath = ''.obs;
  final profileImageVersion = 0.obs;
  final isUpdatingPhoto = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  Future<Person?> getPersonInformation(int personId) async {
    // Aquí va la lógica para obtener la información de la persona.
    var person = await Person().getById(personId);
    currentPerson.value = person;
    final storedPath = await ProfileImageStore.getImagePath(personId);
    profileImagePath.value = storedPath ?? '';
    profileImageVersion.value++;
    return person;
  }

  Future<void> pickImageFromCamera(int personId) async {
    await _pickAndSaveImage(personId, ImageSource.camera);
  }

  Future<void> pickImageFromGallery(int personId) async {
    await _pickAndSaveImage(personId, ImageSource.gallery);
  }

  Future<void> resetProfileImage(int personId) async {
    if (isUpdatingPhoto.value) {
      return;
    }

    try {
      isUpdatingPhoto.value = true;

      final storedPath = await ProfileImageStore.getImagePath(personId);
      if (storedPath != null && storedPath.isNotEmpty) {
        final file = File(storedPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      await ProfileImageStore.removeImagePath(personId);
      profileImagePath.value = '';
      profileImageVersion.value++;
      showSnackbar(
        'Foto de perfil restablecida',
        type: AppSnackbarType.success,
      );
    } catch (_) {
      showSnackbar(
        'No se pudo restablecer la foto de perfil',
        type: AppSnackbarType.error,
      );
    } finally {
      isUpdatingPhoto.value = false;
    }
  }

  Future<void> _pickAndSaveImage(int personId, ImageSource source) async {
    if (isUpdatingPhoto.value) {
      return;
    }

    try {
      isUpdatingPhoto.value = true;

      final XFile? selectedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (selectedImage == null) {
        return;
      }

      final person = await Person().getById(personId);
      if (person == null) {
        showSnackbar(
          'No se encontró la información del usuario',
          type: AppSnackbarType.error,
        );
        return;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final imagePath = '${appDir.path}/profile_person_$personId.jpg';
      await selectedImage.saveTo(imagePath);

      await ProfileImageStore.saveImagePath(personId, imagePath);

      currentPerson.value = person;
      profileImagePath.value = imagePath;
      profileImageVersion.value++;
      showSnackbar('Foto de perfil actualizada', type: AppSnackbarType.success);
    } catch (_) {
      showSnackbar(
        'Error al seleccionar la imagen',
        type: AppSnackbarType.error,
      );
    } finally {
      isUpdatingPhoto.value = false;
    }
  }

  Future<bool> rememberIsChecked() async {
    bool? enabled = await SharedPreferencesHelper.getBool("remember");
    remember.value = enabled!;
    return enabled;
  }

  Future<void> setRemember(bool value) async {
    remember.value = value;
    await SharedPreferencesHelper.setBool("remember", value);
  }
}
