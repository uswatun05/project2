import 'package:flutter/material.dart';
import 'todo_home_page.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          themeMode: mode,
          theme: buildTheme(),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            cardColor: Colors.grey[900],
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
          ),
          home: const TodoHomePage(),
        );
      },
    );
  }
}
