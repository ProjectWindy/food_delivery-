import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/locator.dart';
import 'package:food_delivery/common/service_call.dart';
import 'package:food_delivery/firebase_options.dart';
import 'package:food_delivery/services/home.dart';
import 'package:food_delivery/view/login/welcome_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/on_boarding/startup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/globs.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/services/cart.dart';

SharedPreferences? prefs;

Future<void> initializeApp() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize services
    setUpLocator();

    await initializeApp();

    prefs = await SharedPreferences.getInstance();

    Widget initialScreen;

    if (Globs.udValueBool(Globs.userLogin)) {
      ServiceCall.userPayload = Globs.udValue(Globs.userPayload);

      if (ServiceCall.userPayload['role'] == 'admin') {
        ServiceCall.userRole = 'admin';
      } else {
        ServiceCall.userRole = 'users';
      }

      initialScreen = MainTabView();
    } else {
      initialScreen = StartupView();
    }

    configLoading();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => Cart()),
        ],
        child: MyApp(
          defaultHome: initialScreen,
        ),
      ),
    );
  } catch (e) {
    print('Error in main: $e');
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.yellow
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: widget.defaultHome,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case "welcome":
            // return MaterialPageRoute(builder: (context) => const WelcomeView());
            return MaterialPageRoute(builder: (context) => const WelcomeView());
          case "Home":
            return MaterialPageRoute(builder: (context) => const MainTabView());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text("No path for ${routeSettings.name}"),
                ),
              ),
            );
        }
      },
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
