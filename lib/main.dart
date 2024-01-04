import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_share/src/core/di/di.dart';
import 'package:rb_share/src/core/provider/connection_provider.dart';
import 'package:rb_share/src/core/provider/file_provider.dart';
import 'package:rb_share/src/core/route/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  // initPlugins();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProvider(create: (context) => ConnectionProvider()),
      ],
      child: MaterialApp.router(
        title: 'RB Share',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF440A64),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
