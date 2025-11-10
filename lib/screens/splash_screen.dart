
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uielem/pages/main_page.dart';
import 'package:uielem/providers/channel_drama_provider.dart';
import '../pages/error_page.dart';
import '../pages/login_page.dart';
import '../providers/drama_provider.dart';
import '../providers/network_provider.dart';
import '../providers/social_media_ranking_provider.dart';
import '../providers/tv_ratings_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

   // _initializeApp();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await _checkFirebaseConnection();
  //  FlutterNativeSplash.remove();
      await _initializeApp();
      await requestNotificationPermission();
     });
  }
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _initializeApp() async {
    try {
      // final dramaProvider = Provider.of<DramaProvider>(context, listen: false);
      // await dramaProvider.fetchData();
      await Provider.of<ChannelDramaProvider>(context, listen: false).fetchChannelDramas();
      await Provider.of<TvRatingProvider>(context, listen: false).fetchInitialRatings();
      await Provider.of<SocialMediaProvider>(context, listen: false).fetchInitialRatings();

      // await dramaProvider.fetchChannelDramas();

    // final user=  await FirebaseAuth.instance.authStateChanges().first;
    User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPage()),
        );
      } else {
        // User is not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
       }
    } catch (error) {
      // Handle error, maybe navigate to an ErrorPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ErrorPage(errorMessage: error.toString(), onRetry: () {  },)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    return Scaffold(

    body:

    // Gradient background
    Container(

    decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment(-0.93, -1.0), // approx for 168.93deg
      end: Alignment(1.0, 1.0),       // towards bottom right
      colors: [
        Color(0xFFDA1F26), // red shade
        Color(0xFF151515), // dark shade
      ],
      stops: [-0.32, 1.43], // Simulate positions like -32.15% and 143.07%
    ),
    ),
      child:Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/splash.png",width: double.infinity, // Make the image take full width
            fit: BoxFit.cover,height:MediaQuery.of(context).size.height * 0.7,
            // any height you want
           ),

          Image.asset("assets/images/PakTvDramaLogo.png",height:MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              textAlign: TextAlign.center,
              "Watch Unlimited Tv Shows & Drama"
               " Anywhere, Any Time",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),

              CircularProgressIndicator(color: Color(0xFFDA1F26)),
          // other widgets...
        ],
      ),

    ),

    );
  }
}
