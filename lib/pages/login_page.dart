import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../background/background_task_handler.dart';
import '../background/video_check_service.dart';
import '../providers/favourite_dramas_provider.dart';
import '../providers/user_provider.dart';
import 'main_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  User? _user;
  Future<User?> loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final _auth = FirebaseAuth.instance;
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await _auth.signInWithCredential(cred);
      setState(() {
        _user = result.user;
      });

      final userId = _user?.uid;
      if (userId != null) {
        try {
          await Provider.of<UserProvider>(context, listen: false).fetchUserData();
          await Provider.of<FavoriteDramaProvider>(context, listen: false).loadFavorites();

          await Workmanager().registerPeriodicTask(
            "checkNewVideosTask",
            "check_new_videos_$userId",
            inputData: {'userId': userId},
            frequency: Duration(hours: 12), // Or 6 if your app justifies it
            initialDelay: Duration(minutes: 1),
          );
          // await Workmanager().registerOneOffTask(
          //   "checkNewVideosTask",
          //   "check_new_videos_$userId",
          //   inputData: {'userId': userId},
          //   initialDelay: Duration(seconds: 5),
          // );

          print("✅ Work manager task registered");
        } catch (e) {
          print("❌ Failed to register task: $e");
        }





      }


      return _user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
      return null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width:double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // This is the first image that will appear at the top (at the bottom of the stack)
            Image.asset(
              "assets/images/splash.png",
              width: double.infinity, // Make the image take full width
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
 Positioned(
   top:100,
   left:0,
   right:0,

   child: Image.asset(
   "assets/images/PakTvDramaLogo.png",

   height: 50,
 ),),
            // This is the gradient container that will overlay the top part of the image (on top of the image)
            Positioned(
              bottom: 0, // Place it at the bottom of the screen to overlay the top of the image
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5, // Adjust this based on how much gradient you want
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, // Gradient starts from the bottom
                    end: Alignment.topCenter,       // Gradient ends at the top
                    colors: Theme.of(context).scaffoldBackgroundColor==Colors.black?[
                      Color(0xFF26272B),  // Dark gray shade
                      Color(0x0029292F),  // Transparent color
                    ]:[
                      Color(0xFFFFFFFF),  // Pure white
                  Color(0x00FFFFFF),  // Transparent white
                  ],
                    stops: [0.8537,1.9222], // Stops to simulate the gradient stops
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Welcome to Pak Tv Dramas",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please Login to enjoy more benefits\nand we won’t let you go",
                        style: TextStyle(fontSize: 16, color: Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),


                    if(_isLoading==true)CircularProgressIndicator(color: Color(0xFFDA1F26)),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        final user = await loginWithGoogle();

                        print("login is succesful");
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => MainPage()),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,  // Background color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),  // Rounded corners
                          side: BorderSide(color: Colors.black),  // Border color
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),  // Padding
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,  // Make the row as small as possible
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',  // Add your Google logo here
                            height: 24,  // Image height
                            width: 24,   // Image width
                          ),
                          SizedBox(width: 10),  // Space between image and text
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );




  }
}
