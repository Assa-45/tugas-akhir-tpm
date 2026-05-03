import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

import 'models/analysisresult_model.dart';
import 'models/chatmessage_model.dart';
import 'models/nearbystorecache_model.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AnalysisResultAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(NearbyStoreAdapter());

  await Hive.openBox<User>('userBox');
  await Hive.openBox<AnalysisResult>('analysisBox');
  await Hive.openBox<ChatMessage>('chatBox');
  await Hive.openBox<NearbyStore>('storeBox');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ChromaMeApp());
}


class ChromaMeApp extends StatelessWidget {
  const ChromaMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChromaMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}