// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/bills_provider.dart';
import 'core/providers/biometric_provider.dart';
import 'core/services/firebase_api.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/charts/viewmodel/charts_viewmodel.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
    FirebaseApi.instance.firebaseMessagingBackgroundHandler,
  );
  await FirebaseApi.instance.initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BillsProvider()),
            ChangeNotifierProvider(create: (_) => ChartsViewModel()),
            ChangeNotifierProvider(create: (_) => BiometricProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RQ Balay Tracker',
            theme: AppTheme.lightTheme,
            home: LoginScreen(),
          ),
        );
      },
    );
  }
}
