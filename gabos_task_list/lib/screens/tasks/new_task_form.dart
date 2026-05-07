import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/new_task_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/input_decorations.dart';
import 'package:gabos_task_list/tools/tools.dart';
import 'package:gabos_task_list/widgets/custom_app_bar.dart';
import 'package:gabos_task_list/widgets/input_wrapper.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewTasKForm extends StatelessWidget {
  const NewTasKForm({super.key, this.task});

  final Task? task;

  Widget _reminderDropdown(NewTaskController c) {
    return InputWrapper(
      fillColor: Colors.grey[200],
      padding: 5,
      child: Obx(
        () => DropdownButtonFormField<int>(
          initialValue: c.reminderCode.value,
          items: const [
            DropdownMenuItem(value: 0, child: Text('Sin recordatorio')),
            DropdownMenuItem(value: 1, child: Text('15 minutos antes')),
            DropdownMenuItem(value: 2, child: Text('30 minutos antes')),
            DropdownMenuItem(value: 3, child: Text('1 hora antes')),
            DropdownMenuItem(value: 4, child: Text('1 día antes')),
            DropdownMenuItem(value: 5, child: Text('1 semana antes')),
          ],
          onChanged: (value) {
            c.reminderCode.value = value ?? 0;
          },
          decoration: InputDecorations.defaultInputDecoration(
            hintText: 'Recordatorio',
            labelText: 'Recordatorio',
            prefixIcon: Icons.alarm,
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
      ),
    );
  }

  GestureDetector _taskDueDate(BuildContext context, NewTaskController c) {
    return GestureDetector(
      onTap: () async {
        final initialDate =
            DateTime.tryParse(c.dateController.text) ?? DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          c.dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: InputWrapper(
          fillColor: Colors.grey[200],
          padding: 5,
          child: TextFormField(
            readOnly: true,
            controller: c.dateController,
            decoration: InputDecorations.defaultInputDecoration(
              labelText: 'Fecha de vencimiento',
              hintText: 'Fecha de vencimiento',
              fillColor: Colors.grey[200],
              filled: true,
              prefixIcon: Icons.calendar_today,
            ),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Widget _taskDescription(NewTaskController c) {
    return InputWrapper(
      fillColor: Colors.grey[200],
      padding: 5,
      child: TextFormField(
        controller: c.descriptionController,
        maxLines: 5,
        maxLength: 1000,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecorations.defaultInputDecoration(
          hintText: 'Descripcion de la tarea',
          labelText: 'Descripcion',
          prefixIcon: Icons.description,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  Widget _taskName(NewTaskController c) {
    return InputWrapper(
      fillColor: Colors.grey[200],
      padding: 5,
      child: TextFormField(
        controller: c.titleController,
        validator: (value) {
          return (value != null && value.length >= 3)
              ? null
              : 'El titulo debe de ser de 3 caracteres al menos';
        },
        maxLength: 100,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecorations.defaultInputDecoration(
          hintText: 'Titulo de la tarea',
          labelText: 'Titulo',
          prefixIcon: Icons.task,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  Widget _taskDueTime(BuildContext context, NewTaskController c) {
    return GestureDetector(
      onTap: !c.enabledHours.value
          ? null
          : () async {
              final pickedTime = await _selectTime(context);

              if (pickedTime != null) {
                final finalDateTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                c.timeController.text = DateFormat(
                  'HH:mm',
                ).format(finalDateTime);
              }
            },
      child: AbsorbPointer(
        child: InputWrapper(
          fillColor: Colors.grey[200],
          padding: 5,
          child: TextFormField(
            readOnly: true,
            enabled: c.enabledHours.value,
            controller: c.timeController,
            decoration: InputDecorations.defaultInputDecoration(
              labelText: 'Hora de vencimiento',
              hintText: 'Hora de vencimiento',
              fillColor: Colors.grey[200],
              filled: true,
              prefixIcon: Icons.access_time,
            ),
          ),
        ),
      ),
    );
  }

  IconButton _saveTaskButton(NewTaskController c, GlobalValuesController gvc) {
    return IconButton(
      onPressed: () async {
        if (!c.formKey.currentState!.validate()) {
          return;
        }

        c.title.value = c.titleController.text;
        c.description.value = c.descriptionController.text;
        c.dueDate.value = DateTime.parse(
          '${c.dateController.text} ${c.enabledHours.value ? c.timeController.text : '23:59:59'}',
        );

        final response = await c.saveTask(gvc.personId.value);

        if (response.responseCode == 0) {
          Get.back(result: true);
        }

        showSnackbar(
          response.responseText,
          type: response.responseCode == 0
              ? AppSnackbarType.success
              : AppSnackbarType.error,
        );
      },
      icon: const Icon(Icons.save),
    );
  }

  Widget _createEnabledHourSwitch(NewTaskController c) {
    return Row(
      children: [
        const Text('Hora habilitada'),
        const SizedBox(width: 10.0),
        Obx(
          () => Switch(
            value: c.enabledHours.value,
            onChanged: (value) {
              c.enabledHours.value = value;
            },
            activeThumbColor: activeTrackColor,
            activeTrackColor: strongBlue,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NewTaskController(task: task));
    final gvc = Get.find<GlobalValuesController>();

    return Obx(() {
      if (c.isLoading.value) {
        return const SafeArea(
          child: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }

      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: task == null ? 'Nueva tarea' : 'Detalle de tarea',
            actions: [_saveTaskButton(c, gvc)],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: c.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _taskName(c),
                    defaultVSpace,
                    _taskDescription(c),
                    defaultVSpace,
                    _taskDueDate(context, c),
                    defaultVSpace,
                    Obx(() => _taskDueTime(context, c)),
                    _createEnabledHourSwitch(c),
                    defaultVSpace,
                    _reminderDropdown(c),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
