import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/new_task_controller.dart';
import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/tools/input_decorations.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:gabos_task_list/widgets/custom_app_bar.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewTasKForm extends StatelessWidget {
  NewTasKForm({Key? key}) : super(key: key);

  final TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  );

  final TextEditingController _titleController = TextEditingController();

  GestureDetector _taskDueDate(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
            // Actualiza el texto del controlador con la fecha y hora seleccionadas
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          controller: _dateController,
          decoration: InputDecorations.defaultInputDecoration(
            labelText: 'Fecha de vencimiento',
            hintText: 'Fecha de vencimiento',
            //Color de fondo
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: Icons.calendar_today,
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async{
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    return pickedTime;
  }

  TextFormField _taskDescription() {
    return TextFormField(
      controller: _descriptionController,
      //Multiples lineas
      maxLines: 5,
      maxLength: 1000,
      decoration: InputDecorations.defaultInputDecoration(
        hintText: "Descripción de la tarea", labelText: "Descripción",
        prefixIcon: Icons.description,
        fillColor: Colors.grey[200],
        filled: true,
        ),
        validator: (value) {
          return null;
        },
    );
  }

  TextFormField _taskName() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        return (value != null && value.length >= 3) 
        ? null 
        : 'El titulo debe de ser de 3 caracteres al menos';
      
      },
      maxLength: 100,
      decoration: InputDecorations.defaultInputDecoration(
        hintText: "Titulo de la tarea", 
        labelText: "Titulo", 
        prefixIcon: Icons.task,
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }

  GestureDetector _taskDueTime(BuildContext context) {
    NewTaskController newTaskController = Get.find<NewTaskController>();
    return GestureDetector(
      onTap: !newTaskController.enabledHours.value ? null : () async {
        final TimeOfDay? pickedTime = await _selectTime(context);

        if (pickedTime != null) {
          final DateTime finalDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Actualiza el texto del controlador con la fecha y hora seleccionadas
          _timeController.text = DateFormat('HH:mm').format(finalDateTime);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          enabled: newTaskController.enabledHours.value,
          controller: _timeController,
          decoration: InputDecorations.defaultInputDecoration(
            labelText: 'Hora de vencimiento',
            hintText: 'Hora de vencimiento',
            //Color de fondo
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: Icons.access_time,
          ),
        ),
      ),
    );
  }

  IconButton _saveTaskButton(NewTaskController newTaskController, GlobalValuesController globalValuesController) {
    return IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Guardar la tarea
                newTaskController.title.value = _titleController.text;
                newTaskController.description.value = _descriptionController.text;
                newTaskController.dueDate.value = DateTime.parse(
                  '${_dateController.text} ${newTaskController.enabledHours.value ? _timeController.text : "23:59:59"}',
                );
                GenericResponse response = await newTaskController.createNewTask(globalValuesController.personId.value);
                if (response.responseCode == 1) {
                  Get.back();
                }
                showSnackbar(response.responseText);
              }
            },
            icon: const Icon(Icons.save),
          );
  }

  _createEnabledHourSwitch() {
    return Row(
      children: [
        const Text('Hora habilitada'),
        const SizedBox(width: 10.0,),
        Obx(() => Switch(
          value: Get.find<NewTaskController>().enabledHours.value,
          onChanged: (value) {
            Get.find<NewTaskController>().enabledHours.value = value;
          },
          activeColor: activeTrackColor,
          activeTrackColor: strongBlue,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    NewTaskController newTaskController = Get.put(NewTaskController());
    GlobalValuesController globalValuesController = Get.find<GlobalValuesController>();
    return Obx(() => SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Nueva tarea',
          actions: [
            _saveTaskButton(newTaskController, globalValuesController),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _taskName(),
                  defaultVSpace,
                  _taskDescription(),
                  defaultVSpace,
                  _taskDueDate(context),
                  defaultVSpace,
                  _taskDueTime(context),
                  defaultVSpace,
                  _createEnabledHourSwitch(),
                ],
              ),
            ),
          )
        ),
      ),
    ));
  }
}
