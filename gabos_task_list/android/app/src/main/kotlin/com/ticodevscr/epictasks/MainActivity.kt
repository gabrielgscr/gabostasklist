package com.ticodevscr.epictasks

import android.app.NotificationManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val notificationsMaintenanceChannel =
		"gabos_task_list/notifications_maintenance"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(
			flutterEngine.dartExecutor.binaryMessenger,
			notificationsMaintenanceChannel,
		).setMethodCallHandler { call, result ->
			when (call.method) {
				"clearCorruptedNotificationState" -> {
					try {
						clearCorruptedNotificationState()
						result.success(true)
					} catch (e: Exception) {
						result.error(
							"cleanup_failed",
							e.message,
							e.stackTraceToString(),
						)
					}
				}

				else -> result.notImplemented()
			}
		}
	}

	private fun clearCorruptedNotificationState() {
		applicationContext
			.getSharedPreferences("scheduled_notifications", Context.MODE_PRIVATE)
			.edit()
			.clear()
			.apply()

		applicationContext
			.getSharedPreferences("flutter_local_notifications_plugin", Context.MODE_PRIVATE)
			.edit()
			.clear()
			.apply()

		val notificationManager =
			getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
		notificationManager.cancelAll()
	}
}
