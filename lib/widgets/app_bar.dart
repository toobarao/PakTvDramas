import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../screens/search_screen.dart';
class AppBarNav extends StatelessWidget {
  final String currentPage;

  final Function(int)? onNavSelected;
  const AppBarNav({super.key, required this.currentPage, this.onNavSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'assets/images/home_d1.png',
      'assets/images/home_d2.png',
      'assets/images/home_d3.png',
      'assets/images/home_d4.png',

    ];
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 360,  // Adjust this height as per your design
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent, // Transparent to show the gradient effect
      elevation: 0, // No shadow to avoid overlap
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [

            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1.0,
                aspectRatio: 1.0,
                height: 360,
              ),
              items: imageUrls.map((url) {
                return Image.asset(
                  url,
                  fit: BoxFit.fill,
                  width: double.infinity,
                );
              }).toList(),
            ),


            // Content like the logo and search bar on top of the gradient
            Container(
              width: double.infinity, // Adjust width as needed
              height: 100, // Adjust height as needed
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9), // Dark black at the top
                    Colors.black.withOpacity(0.7), // Medium black
                    Colors.black.withOpacity(0.4), // Lighter black
                    Colors.black.withOpacity(0.1), // Almost transparent
                  ],
                ),
              ),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10), // Adjust padding as necessary
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Top Row: Logo and Search Bar
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10), // Adjust padding here
                  //   child:

                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10) ),
child:
                        Image.asset('assets/images/logo.png', height: 35)),
                      Text("PakTvDramas",style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins, sans-serif',
                      ),),
                      Container(
                        width: 200,
                        height: 25,

                        child: TextField(
                          controller: TextEditingController(),
                          readOnly: true,
                          onTap: () {
                            // Navigate to your desired screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SearchScreen()), // ← Replace with your screen
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "search..",
                            hintStyle: TextStyle(
                              color: Colors.white, // Change color
                              fontSize: 15, // Change font size
                              fontWeight: FontWeight.w500, // Adjust weight
                              fontStyle: FontStyle.italic, // Italic style (optional)
                            ),
                            prefixIcon: Icon(Icons.search,color: Colors.white,),
                            fillColor: Colors.white.withOpacity(0.3),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          //textAlignVertical: TextAlignVertical.center,
                        ),

                      ),
                    ],
                  ),

                  // ),


                  Container(
                    // height: 30,

                    child: SingleChildScrollView(

                      scrollDirection: Axis.horizontal,

                      child:
                      Row(

                        children: [
                          _navButton(context, 'Home', 0, 'home'),
                          _navButton(context, 'TV Ratings', 2, 'tvrating'),
                          _navButton(context, 'Social Media', 3, 'social'),
                          _navButton(context, 'Recommendations', 4, 'recommendations'),
                          // _navButton(context, 'Home', HomePage(), 'home'),
                          // SizedBox(width: 10),
                          // _navButton(context, 'All Channels Dramas', HomePage(), 'all'),
                          // SizedBox(width: 10),
                          // _navButton(context, 'TV Ratings', TvRatingsPage(), 'tvrating'),
                          // SizedBox(width: 10),
                          // _navButton(context, 'Social Media Rankings', SocialMediaRankings(), 'social'),
                          // SizedBox(width: 10),
                          // _navButton(context, 'Recommendations', RecommendationsPage(), 'recommendations'),

                        ],
                      ),

                    ),
                  ),
                  // ),
                ],
              ),

            ),
          ],
        ),
      ),
    )
    ;
  }


  Widget _navButton(BuildContext context, String label, int index, String pageKey) {
    final bool isActive = currentPage == pageKey;
    return Column(
      children: [
        TextButton(
          onPressed: () {
            if (!isActive && onNavSelected != null) {
              onNavSelected!(index);
            }
          },
          child: Text(
            label,
            style:Theme.of(context).textTheme.headlineMedium?.copyWith(
                           color: isActive ? Colors.white : Colors.white,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                       ),


          ),
        ),
        if (isActive) Container(height: 2, width: 40, color: Colors.red),
      ],
    );
  }

  // Widget _navButton(BuildContext context, String label, Widget targetPage, String pageKey) {
  //   final bool isActive = currentPage == pageKey;
  //   return   Column(
  //     children: [
  //       TextButton(
  //         style: TextButton.styleFrom(
  //           padding: EdgeInsets.zero,
  //         ),
  //         onPressed: () {
  //           if (!isActive) {
  //             Navigator.of(context).pushReplacement(_createSlideRoute(targetPage));
  //           }
  //         },
  //         child: Text(
  //           label,
  //           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //             color: isActive ? Colors.white : Colors.white,
  //             fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       if (isActive)
  //         Container(
  //           height: 2,
  //           width: 40,
  //           color: Colors.redAccent,
  //         ),
  //     ],
  //   );
  //   //   TextButton(
  //   //   style: TextButton.styleFrom(
  //   //
  //   //     padding: EdgeInsets.zero, // Removes any padding
  //   //     // Set your desired background color
  //   //   ),
  //   //   onPressed: () {
  //   //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => targetPage));
  //   //   },
  //   //   child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
  //   // );
  // }
  /// Slide transition route


















  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from right
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
