import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/model/user_info.dart';
import 'package:gabos_task_list/screens/dashboard/welcome_screen.dart';
import 'package:gabos_task_list/screens/login/login_screen.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:gabos_task_list/tools/password_encryption.dart';
import 'package:gabos_task_list/tools/shared_preferences_helper.dart';
import 'package:gabos_task_list/tools/store.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  tz.initializeTimeZones();
  LocalNotificationHelper.initializeLocalNotifications();
  return runApp(const MyApp());
} 

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isRememberMeActive = false;
  bool _areCredentialsValid = false;
  Person? _person;

  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
    _initPreferences();
    super.initState();
  }

  Future<void> _initPreferences() async {
    
    _isRememberMeActive = await rememberIsChecked();
    if(_isRememberMeActive){
      UserInfo info = await getUserInfo();
      GenericResponse response = await login(info.name, info.password);
      if (response.responseCode == 1) {
        _person = response.responseObject as Person;
        _areCredentialsValid = true;
      }
    } else {
      _areCredentialsValid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalValuesController c = Get.put(GlobalValuesController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      //routes: routes,
      onGenerateRoute: (settings) {
        
        switch (settings.name) {
          case '/':
            if(_isRememberMeActive && _areCredentialsValid){
              c.personId.value = _person!.personId!;
              c.username = _person!.email!;
              return MaterialPageRoute(builder: (context) =>
                const WelcomeScreen()
            );
            }
            return MaterialPageRoute(builder: (context) =>
                const LoginScreen()
            );

          case '/notification-page':
            return MaterialPageRoute(builder: (context) {
              final ReceivedAction receivedAction = settings
                  .arguments as ReceivedAction;
              //return MyNotificationPage(receivedAction: receivedAction);
              return const LoginScreen();
            });

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      theme: appTheme,
    );
  }

  Future<bool> rememberIsChecked() async {
    bool? enabled = await SharedPreferencesHelper.getBool("remember");
    return enabled!;
  }

  Future<GenericResponse> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return GenericResponse(-1, 'Usuario y contraseña son requeridos');
    } else {
      Person? person =
          await Person().select().email.equals(username).toSingle();
      if (person == null) {
        return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
      } else {
        String cyphPass = PasswordEncryption.encryptPassword(password);
        if (person.password == cyphPass) {
          return GenericResponse(1, 'Usuario autenticado', responseObject: person);
        } else {
          return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
        }
      }
    }
  }
}


class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
            (route) => (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}