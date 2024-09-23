import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reflect/components/signup/bg_splash.dart';
import 'package:reflect/models/entry.dart';
import 'package:reflect/pages/auth.dart';
import 'package:reflect/pages/entry.dart';
import 'package:reflect/pages/entrylist.dart';
import 'package:reflect/pages/entry.dart';
import 'package:reflect/pages/login.dart';
import 'package:reflect/pages/navigation.dart';
import 'package:reflect/theme/theme_constants.dart';
import 'package:reflect/theme/theme_manager.dart';


final themeManagerProvider = StateNotifierProvider<ThemeManager, ThemeData>((ref) => ThemeManager());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.openBox('chapters');
  Hive.openBox('entries');
  Hive.openBox('settings');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeManagerProvider);
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeData.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => const AuthPage(),
        '/login': (context) => const LoginPage(),
        '/navigation': (context) => const NavigationPage(),
        '/entrylist': (context) => const EntryListPage(),
        '/entry': (context) => EntryPage(entry: Entry(),),
      },
    );
  }
}
