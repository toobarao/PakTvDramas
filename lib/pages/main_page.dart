import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uielem/pages/social_media_ranking.dart';
import 'package:uielem/pages/tv_rating_page.dart';
import '../screens/search_screen.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/drawer.dart';
import 'channel_grid_page.dart';
import 'home_page.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? lastBackPressed;
  late FToast fToast;
  int _selectedIndex = 0;

  // Pages to show
  final List<Widget> _pages = [
    HomePage(),
    ChannelGridPage(),
    TvRatingPage(),
    SocialMediaRankingPage()
   
  ];

  // When tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();


}
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          if (lastBackPressed == null ||
              now.difference(lastBackPressed!) > Duration(seconds: 2)) {
            lastBackPressed = now;

            Fluttertoast.showToast(
              msg: "Press back again to exit",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            );
            return false; // block the pop
          }
          return true; // allow the pop (exit app)
        },
        child: SafeArea(child: Scaffold(
          drawer: AppDrawer(),

          appBar:AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true, // center the title (especially on Android)
            title: Image.asset(
              'assets/images/PakTvDramaLogo.png', // your centered logo
              height: 40,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search,color:Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.white:Colors.red ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()), // ← Replace with your screen
                  );
                  // Handle search tap
                },
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body:_pages[_selectedIndex],
          bottomNavigationBar:  BottomNav(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ))
      );
  }



}


