import 'package:flutter/material.dart';
import 'package:onlyhocamsui/pages/Onboarding/LoginScreen.dart';
import 'package:onlyhocamsui/pages/Onboarding/RegisterScreen.dart';
import 'package:onlyhocamsui/pages/user/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnlyHocams',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:  LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/usersplash': (context) => SplashPage(),
        '/register': (context) =>RegisterScreen(),
        },
    );
  }
}
