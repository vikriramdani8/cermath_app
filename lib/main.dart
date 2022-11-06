import 'dart:io';

import 'package:cermath_app/routing/routes.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: RouterGenerator.generateRoute,
      navigatorObservers: <NavigatorObserver>[routeObserver]
    );
  }
}
