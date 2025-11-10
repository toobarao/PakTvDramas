import 'package:flutter/material.dart';

import '../widgets/faq_section_title.dart';
import '../widgets/paragraph.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Disclaimer",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaqSectionTitle("Disclaimer"),
            Paragraph(
              "These terms and conditions outline the rules and regulations for the use of www.paktvdramas.pk (the “Website”). By accessing this website, you unconditionally accept the Terms and Conditions, Privacy Policy and Disclaimer. Do not continue to use this website if you do not accept all of the terms and conditions stated on this page.",
            ),
            Paragraph(
              "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer and any or all Agreements: “Client”, “You” and “Your” refers to you, the person accessing this website and accepting the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves, or either the Client or ourselves. Any use of the above terminology or other words in the singular, plural, and/or he/she or they, are taken as interchangeable and therefore as referring to same.",
            ),
            Paragraph(
              "This disclaimer is valid for the website as well as all the social media pages of www.paktvdramas.pk. Hence, the usage of website, paktvdramas.pk, including Facebook page, Instagram account, Twitter handle and any other social media page managed or owned by the Company.",
            ),
            Paragraph(
              "Please note that the Company does not own any Content made available on the website. We may use Content provided by third parties on our Website. We are under no obligation to, and do not, scan content used in connection and/or for the inclusion of illegal or impermissible content. The user of this website shall at its own discretion decide on use of the Website.",
            ),
            Paragraph(
              "To the maximum extent permitted by applicable law, we exclude all representations, warranties and relating to our website and the use of this website (including, without limitation, any warranties implied by law in of satisfactory quality, fitness for purpose and/or the use of reasonable care and skill).",
            ),
            Paragraph(
              "The content on the website does not intend to hurt the sentiments or be biased towards or against any individual, society, gender, creed, nation or religion (irrespective of their school of thought). The content published on the website is for entertainment purpose only.",
            ),
            Paragraph(
              "Viewing any content on the website/ social media pages is a conscious choice of the visitor. We highly recommend that unless you are completely convinced, it is preferable that you do not view anything on the website that you might find ‘offensive’.",
            ),
            Paragraph(
              "Despite constant warnings, if you still intend to visit the website, you will be doing it completely on your own risk and cannot blame or hold the Website or any of its social media pages accountable for any damages whatsoever (emotional, social, physical, psychological or in any other form that may emerge).",
            ),
            Paragraph(
              "The Company reserves the right to take legal action against pages/ websites/ forums/ social media profiles that publish content copied from/ inspired by www.paktvdramas.pk without permission.",
            ),
            Paragraph(
              "Many articles on the website are shared from third party content providers or other websites and we neither confirm nor deny the authenticity of any facts stated in them. We will not be liable for any false, inaccurate, inappropriate or incomplete information presented on the website.",
            ),
          ],
        ),
      ),
    );
  }



}
