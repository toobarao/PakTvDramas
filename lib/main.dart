
import 'dart:async';
import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uielem/pages/login_page.dart';
import 'package:uielem/providers/channel_drama_provider.dart';
import 'package:uielem/providers/drama_provider.dart';
import 'package:uielem/providers/favourite_dramas_provider.dart';
import 'package:uielem/providers/network_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uielem/providers/social_media_ranking_provider.dart';
import 'package:uielem/providers/tv_ratings_provider.dart';
import 'package:uielem/providers/user_provider.dart';
import 'package:uielem/screens/splash_screen.dart';
import 'package:uielem/background/background_task_handler.dart';
import 'package:uielem/services/notification_service.dart';
import 'package:uielem/utilities/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:uielem/widgets/splash_observer.dart';
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void main() {
    runZonedGuarded(() async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();


      // Firebase
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await NotificationService.init();
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);


      // Hive
      final appDocDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocDir.path);
      await Hive.openBox('dramaCache');

      // HttpOverrides
      HttpOverrides.global = MyHttpOverrides();

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => FavoriteDramaProvider()),
            ChangeNotifierProvider(create: (_) => ChannelDramaProvider(),),
            ChangeNotifierProvider(create: (_) => SocialMediaProvider(),),
            ChangeNotifierProvider(create: (_) => TvRatingProvider()),
            ChangeNotifierProvider(create: (_) => NetworkProvider()),
            ChangeNotifierProvider(create: (_) => DramaProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
          ],
          // child:MainAppWrapper(child: MyApp()),Display splash when app resumed(issue after app show splash it shows main page and then display the page user is using.
          child:MainAppWrapper(child: MyApp()),
        ),
      );
    }, (error, stackTrace) {
      print('Uncaught async error: $error');
    });
  }



















class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


        return MaterialApp(
            useInheritedMediaQuery: true,
            navigatorKey: navigatorKey,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
          title: 'PakTvDramas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(Brightness.light),
          darkTheme: AppTheme.getTheme(Brightness.dark),

          themeMode:ThemeMode.system,
          home:  SplashPage()
        );


  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
