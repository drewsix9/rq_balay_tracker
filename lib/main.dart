// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/logger/app_logger.dart';
import 'core/providers/bills_provider.dart';
import 'core/providers/biometric_provider.dart';
import 'core/services/firebase_api.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_screen.dart';
import 'features/charts/viewmodel/charts_viewmodel.dart';
import 'features/landing_page/viewmodel/landing_page_viewmodel.dart';
import 'features/profile/viewmodel/edit_profile_dialog_provider.dart';
import 'features/profile/viewmodel/profile_screen_viewmodel.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Fix: Use the correct static background handler from FirebaseApi
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
    // Determine device width to set designSize dynamically
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final deviceWidth = mediaQuery.size.width;
    Size designSize;
    if (deviceWidth < 600) {
      designSize = const Size(375, 812);
    } else if (deviceWidth < 800) {
      designSize = const Size(800, 1200);
    } else {
      designSize = const Size(1200, 1600);
    }

    AppLogger.d('Design Size: $designSize');

    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BillsProvider()),
            ChangeNotifierProvider(create: (_) => ChartsViewModel()),
            ChangeNotifierProvider(create: (_) => BiometricProvider()),
            ChangeNotifierProvider(create: (_) => LandingPageViewModel()),
            ChangeNotifierProvider(create: (_) => EditProfileDialogProvider()),
            ChangeNotifierProvider(create: (_) => ProfileScreenViewmodel()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RQ Balay Tracker',
            theme: AppTheme.lightTheme,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
