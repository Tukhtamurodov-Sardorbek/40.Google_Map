import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_integration/pages/splash/splash_page.dart';
import 'package:google_map_integration/services/color_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // #StatusBar & NavigationBar Color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorService.main,
      systemNavigationBarColor: ColorService.main,
    ),
  );
  // #Orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Maps',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: ColorService.main,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorService.main,
          elevation: 0,
        ),
      ),
      home: const SplashPage(),
    ),
  );
}
