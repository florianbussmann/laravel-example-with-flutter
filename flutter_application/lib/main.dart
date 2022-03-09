import 'package:flutter/material.dart';
import 'package:flutter_application/providers/AuthProvider.dart';
import 'package:flutter_application/providers/CategoryProvider.dart';
import 'package:flutter_application/screens/categories.dart';
import 'package:flutter_application/screens/home.dart';
import 'package:flutter_application/screens/login.dart';
import 'package:flutter_application/screens/register.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryProvider>(
              create: (context) => CategoryProvider(authProvider),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              primarySwatch: Colors.blue,
            ),
            routes: {
              '/': (context) {
                final authProvider = Provider.of<AuthProvider>(context);
                if (authProvider.isAuthenticated) {
                  return Categories();
                } else {
                  return Login();
                }
              },
              '/login': (context) => Login(),
              '/register': (context) => Register(),
              '/categories': (context) => Categories(),
            },
          ),
        );
      }),
    );
  }
}
