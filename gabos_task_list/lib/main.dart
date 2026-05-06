import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/model/user_info.dart';
import 'package:gabos_task_list/routes/routes.dart';
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
  await LocalNotificationHelper.initializeLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _areCredentialsValid = false;
  bool _isRememberMeActive = false;
  Person? _person;

  @override
  void initState() {
    LocalNotificationHelper.requestLocalNotificationPermission();
    super.initState();
  }

  Future<bool> rememberIsChecked() async {
    bool? enabled = await SharedPreferencesHelper.getBool("remember");
    return enabled!;
  }

  Future<GenericResponse> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return GenericResponse(-1, 'Usuario y contraseña son requeridos');
    } else {
      Person? person = await Person()
          .select()
          .email
          .equals(username)
          .toSingle();
      if (person == null) {
        return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
      } else {
        String cyphPass = PasswordEncryption.encryptPassword(password);
        if (person.password == cyphPass) {
          return GenericResponse(
            1,
            'Usuario autenticado',
            responseObject: person,
          );
        } else {
          return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
        }
      }
    }
  }

  Future<void> _initPreferences() async {
    _isRememberMeActive = await rememberIsChecked();
    if (_isRememberMeActive) {
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

  GetMaterialApp _buildMaterialApp(GlobalValuesController c) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        FlutterNativeSplash.remove();
        switch (settings.name) {
          case '/':
            if (_isRememberMeActive && _areCredentialsValid) {
              c.personId.value = _person!.personId!;
              c.username = _person!.email!;
              return MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              );
            }
            return MaterialPageRoute(builder: (context) => const LoginScreen());

          case '/notification-page':
            return MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            );

          default:
            // Intenta usar el mapa de rutas estándar (sin el /)
            final routeKey = settings.name?.replaceFirst('/', '') ?? '';
            if (routeKey.isNotEmpty && routes.containsKey(routeKey)) {
              return MaterialPageRoute(
                builder: routes[routeKey]!,
                settings: settings,
              );
            }
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

  @override
  Widget build(BuildContext context) {
    GlobalValuesController c = Get.put(GlobalValuesController());
    return FutureBuilder(
      future: _initPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildMaterialApp(c);
        } else {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}
