import 'package:flutter/material.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor:   Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.grey[900]:Colors.white,
      
      
      body:SingleChildScrollView(

        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    "About Us",
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
      
                child: Image.asset('assets/images/PakTvDramaLogo.png',height: 60,alignment: Alignment.center,),
              ),
            ),
            SizedBox(height: 10.0,),
            sectionText(context,
              "Pak TV Dramas efficiently keeps you updated with the top Pakistani TV Dramas, that you can truly enjoy for exclusive entertainment. "
                  "It is a platform where all TV Dramas are available on a single platform along with their satellite and social media rankings. "
                  "We yearn to provide a unique platform for drama lovers to explore that quality drama content that is not ranked anywhere else across "
                  "the internet or satellite and invite viewer feedback.",
            ),
            SizedBox(height: 10.0,),
      
            sectionText(context,
              "TV ratings or TAM (Total Audience Measurement) is calculated by Analytics software which is based on Audience viewership.",
            ),
      
            SizedBox(height: 10.0,),
            sectionText(context,
              "Top Pakistani TV dramas trending on YouTube based on our unique YouTube ranking matrix and top TV dramas trending on major social networks.",
            ),
      
            SizedBox(height: 10.0,),
            sectionText(context,
              "Recommending you about the top 10 dramas of the season with respect to the audience views on our website.",
            ),
      
            SizedBox(height: 10.0,),
            sectionText(context,
              "Pak TV Dramas recommend you Top 10 Dramas.",
            ),
      
           SizedBox(height: 10.0,),
            sectionText(context,
              "Our mission is to create awareness for quality content in the entertainment genre by providing information about all Pakistani TV Dramas. "
                  "We are looking forward to satisfy the demand of our users!",
            ),
          ],
        ),
      
      
      
        ),
      
      ),
    );
  }


  // Reusable styled paragraph text
  Widget sectionText(BuildContext context,String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

