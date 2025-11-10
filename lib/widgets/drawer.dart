
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uielem/pages/user_profile_page.dart';
import 'package:uielem/screens/about_screen.dart';
import 'package:uielem/screens/terms_condition_screen.dart';
import 'package:workmanager/workmanager.dart';
import '../pages/favourite_dramalist.dart';
import '../pages/login_page.dart';
import '../screens/faq_screen.dart';

import '../screens/privacy_policy.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isLoading = false;
  User? _user;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }
  void _checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }
  Future<void> logout() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId != null) {
        await Workmanager().cancelByUniqueName("check_new_videos_$userId");
      }

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      setState(() {
        _user = null;
      });

      // Navigate to login screen and clear navigation stack
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Logout error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
    // backgroundColor: Colors.grey[900],
    child: ListView(

    padding: EdgeInsets.zero,
    children: <Widget>[

    _user!=null?
      Container(
       // color: Colors.black,
     margin:EdgeInsets.only(top:50.0,bottom: 15.0,left:12.0,right: 12.0),
     height: 50,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,

              backgroundImage:
              _user?.photoURL != null ? NetworkImage(_user!.photoURL!) : AssetImage("assets/images/user_image.png"),

              child: _user?.photoURL == null
                  ? const Icon(Icons.person, size: 60, color: Colors.red)
                  : null,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    _user?.displayName ?? "No Name",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,)


                ),
                Text(
                  _user?.email ?? "",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )

          ],
        ),
      ):


    Container(
      // color: Colors.black,
      margin:EdgeInsets.symmetric(vertical: 20.0,horizontal: 12.0),
      height: 100,

      child: Row(
        children: [
          CircleAvatar(
            radius: 20,


            backgroundColor: Colors.white,
            child:  Icon(Icons.person, size: 30, color: Colors.grey)
              ,
          ),
          const SizedBox(width: 4),


        ],
      ),
    ),

     Container(
       margin:EdgeInsets.only(top:6.0),
       padding:EdgeInsets.only(left:6.0,right:6.0) ,
       height: 660,
       color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Color(0xFF26272B)
       :Color(0xFFE6E6E6)
       ,
      // height: 500,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(
               "General Settings",
               style: Theme
                   .of(context)
                   .textTheme
                   .bodySmall
                   ?.copyWith(
                 fontWeight: FontWeight.w500,
                 color: Colors.grey,
               )),
         ),
         const SizedBox(height: 10),

         _buildProfileOption( "Account Settings", () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfilePage()));
         },icon:Icons.list,color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),


         _buildProfileOption("About Us", () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
         },icon:Icons.settings,color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),
         _buildProfileOption( "Help,Faq", () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => FaqPage()));
         },icon:Icons.help_outline,color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),

             _buildProfileOption( "Favourites", () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => FavouriteDramaListScreen()));
             },icon:Icons.favorite_outlined,color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),

         const SizedBox(height: 10),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(
               "Terms",
               style: Theme
                   .of(context)
                   .textTheme
                   .bodySmall
                   ?.copyWith(
                 fontWeight: FontWeight.w500,
                 color: Colors.grey,
               )),
         ),
         const SizedBox(height: 10),// Nice bottom spacing

         _buildProfileOption( "Terms & Condition", () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => TermsConditionsPage()));
         },color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),
         _buildProfileOption( "Privacy Policy", () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
           );

         },color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red),
           const SizedBox(height: 140),
            if(_user!=null)
                _buildLogoutOption(Icons.logout,Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.red:Colors.black, "Sign Out", logout),




       ],),
     ),

    ],
    ),
    );

    }
  Widget _buildLogoutOption(IconData? icon,Color? color, String title, VoidCallback onTap) {
    return
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: 300, // Margin around the button
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      );
  }
  Widget _buildProfileOption(String title, VoidCallback onTap, {IconData? icon,Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: icon != null
            ? Icon(
              icon,
              size: 32,
              color: color,
            )
            : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing:  Icon(Icons.arrow_forward_ios, size: 14, color: color),
        onTap: onTap,
      ),
    );
  }

}
