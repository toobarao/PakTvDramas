import 'package:flutter/material.dart';

import '../widgets/faq_item.dart';
import '../widgets/faq_section_title.dart';


class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.grey[900]:Colors.white,
      
        body: SingleChildScrollView(
      
      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
          Container(
            height: 70,
      
            margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 3.0),
            child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 25),
              ),

              // Spacer to push the title into center
              const Spacer(),

              // Center title
              const Text(
                "Help,FAQ's",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // Spacer to balance the Row
              const Spacer(),
                ],
                ),
          ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),

                  child: Image.asset('assets/images/PakTvDramaLogo.png',height: 60,),
                ),
              ),
              FaqItem(
                "2. What can I watch on Pak TV Dramas?",
                "Pak TV Dramas has an extensive library of comedy, romantic, thrilling, soaps and classic old dramas of 90's, and more. You can easily watch as much as you want, anytime when you crave entertainment.",
              ),
              FaqItem(
                "3. How is Pak TV Dramas different from others?",
                "Pak TV Dramas comes with a new concept of streaming your favorite dramas on a single platform. By evaluating TV ratings and social media rankings, we recommend you a top 10 trending dramas.",
              ),
              FaqItem(
                "4. How much does Pak TV Dramas cost?",
                "You can effortlessly watch your favorite dramas free of cost on one platform. On top of it all, you can post your views and give your recommendations about your favorites.",
              ),
              FaqItem(
                "5. Where can I watch it?",
                "Watch anywhere, anytime, on an unlimited number of devices. You can also download Pak TV Dramas app on your Android phones. Use our app to watch. You can conveniently take Pak TV Dramas with you anywhere.",
              ),
              FaqItem(
                "6. How can I become a member?",
                "You can follow the given instructions for sign up. Your personal information remains confidential.\n\n"
                    "Visit: paktvdramas.pk/log-in/\n"
                    "Create an account by entering your email address and password.\n"
                    "That's it. Enjoy Pak TV Dramas! You can also easily sign up with your Facebook, LinkedIn, and Google accounts.",
              ),
            ],
          ),
        ),
      ),
    );
  }



}
