import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:gabos_task_list/widgets/custom_app_bar.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class NotificationsDebugScreen extends StatefulWidget {
  const NotificationsDebugScreen({super.key});

  @override
  State<NotificationsDebugScreen> createState() =>
      _NotificationsDebugScreenState();
}

class _NotificationsDebugScreenState extends State<NotificationsDebugScreen> {
  Map<String, bool> _permissions = {};
  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    setState(() => _isLoading = true);

    try {
      final permissions = await LocalNotificationHelper.getPermissionStatus();
      final pending = await LocalNotificationHelper.getPendingNotifications();

      setState(() {
        _permissions = permissions;
        _pendingNotifications = pending;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading debug info: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermissions() async {
    await LocalNotificationHelper.requestLocalNotificationPermission();
    await _loadDebugInfo();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permisos solicitados')));
    }
  }

  Future<void> _scheduleDebugNotification() async {
    final success =
        await LocalNotificationHelper.scheduleDebugNotificationInMinutes();
    await _loadDebugInfo();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Notificación de prueba programada en 2 minutos'
              : 'No se pudo programar la notificación de prueba',
        ),
      ),
    );
  }

  Future<void> _cancelDebugNotification() async {
    await LocalNotificationHelper.cancelDebugNotification();
    await _loadDebugInfo();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificación de prueba cancelada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Diagnóstico de Notificaciones',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDebugInfo,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPermissionsSection(),
                    const SizedBox(height: 24),
                    _buildPendingNotificationsSection(),
                    const SizedBox(height: 24),
                    _buildLogsSection(),
                    const SizedBox(height: 24),
                    _buildActionsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado de Permisos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: _permissions.entries.map((permission) {
              final isGranted = permission.value;
              return ListTile(
                leading: Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  color: isGranted ? Colors.green : Colors.red,
                ),
                title: Text(permission.key),
                subtitle: Text(isGranted ? 'Concedido' : 'No concedido'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificaciones Programadas (${_pendingNotifications.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_pendingNotifications.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('No hay notificaciones programadas'),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pendingNotifications.length,
              itemBuilder: (context, index) {
                final notif = _pendingNotifications[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif.title ?? 'Sin título',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (notif.body != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              notif.body!,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            'ID: ${notif.id}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _requestPermissions,
          icon: const Icon(Icons.check),
          label: const Text('Solicitar Permisos'),
          style: ElevatedButton.styleFrom(
            backgroundColor: strongBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _scheduleDebugNotification,
          icon: const Icon(Icons.schedule),
          label: const Text('Programar Prueba (2 min)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _cancelDebugNotification,
          icon: const Icon(Icons.cancel_schedule_send),
          label: const Text('Cancelar Prueba'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            LocalNotificationHelper.logs.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Historial de logs limpiado')),
            );
          },
          icon: const Icon(Icons.delete_sweep),
          label: const Text('Limpiar Historial de Logs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ],
    );
  }

  Widget _buildLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Logs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final logs = LocalNotificationHelper.logs.reversed.toList();
          if (logs.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Sin logs aún')),
            );
          }

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black87,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length > 25 ? 25 : logs.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white24, height: 8),
              itemBuilder: (_, index) => Text(
                logs[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
