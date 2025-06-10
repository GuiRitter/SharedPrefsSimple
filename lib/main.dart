import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialApp,
        StatelessWidget,
        ThemeMode,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:shared_prefs_simple/theme/import.dart' show dark, light;
import 'package:shared_prefs_simple/ui/page/home.page.dart' show HomePage;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final themeLight = light(
      context: context,
    );

    final themeDark = dark(
      context: context,
    );

    return MaterialApp(
      title: 'Shared Prefs Simple',
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
