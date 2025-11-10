import 'package:flutter/material.dart';
import 'package:uielem/widgets/paragraph.dart';

import '../widgets/about_section_title.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:   Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.grey[900]:Colors.white,
      
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
                      "Terms & Condition",
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
              SectionTitle("Terms & Conditions"),
            Paragraph(
                "These terms and conditions outline the rules and regulations for the use of www.paktvdramas.pk (the “Website”). By accessing this website, you unconditionally accept the Terms and Conditions, Privacy Policy and Disclaimer. Do not continue to use this website if you do not accept all of the terms and conditions stated on this page.",
              ),
              Paragraph(
                "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer and any or all Agreements: “Client”, “You” and “Your” refers to you, the person accessing this website and accepting the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves, or either the Client or ourselves. Any use of the above terminology or other words in the singular, plural, and/or he/she or they, are taken as interchangeable and therefore as referring to same.",
              ),
              SectionTitle("Use of the Website"),
              Paragraph(
                "You may use this Website solely for personal and non-commercial purposes only and subject to these Terms and Conditions. The Website is for entertainment purposes. During your use of this Website, you may provide comments, reviews, ratings, etc. These comments/ reviews/ratings should follow our Acceptable Use Policy as per these Terms and Conditions. The Company has the right to disapprove, delete, remove, ban for use, any use or comment/review/ rating that it feels is inappropriate. We reserve the right in sole discretion for allowing or stopping anyone to use/access our website.",
              ),
              SectionTitle("Registration"),
              Paragraph(
                "You may use the Website without registration, but in order to take advantage of some aspects of the Website, you will need to register for an account. Your account is for your sole, personal use, you may not authorise others to use your account, and you may not assign or otherwise transfer your account to any other person or entity. You are responsible for the security of your password and will be solely liable for any use or unauthorised use under such password.",
              ),
              SectionTitle("Acceptable Use Policy"),
              Paragraph(
                "We expect all of our users to be respectful of other people. If you notice any violation of this Acceptable Use Policy or other unacceptable behaviour by any user, you should report such activity to us at complaint@paktvdramas.pk.",
              ),
              SectionTitle("Privacy"),
              Paragraph(
                "The privacy of your personally identifiable information is very important to us. For more information on what information we collect and how we use such information, please read our privacy policy.",
              ),
              SectionTitle("Cookies"),
              Paragraph(
                "We employ the use of cookies. By using this website you consent to the use of cookies in accordance with our Privacy Policy. Website cookies enable us to retrieve user details for each visit and allow for a better user experience. Cookies are used in some areas of our site to enable the functionality of this area and ease of use for those people visiting. Some of our advertising partners and/or third-party service providers along with social media websites may also use cookies.",
              ),
              SectionTitle("Hyperlinking to our Website"),
              Paragraph(
                "The following organizations may link to our Website without prior written approval:\n• Government agencies\n• Search engines\n• News organizations\n• Online directory distributors when they list us in the directory may link to our Website in the same manner as they hyperlink to the websites of other listed businesses.",
              ),
              Paragraph(
                "These organizations may link to our home page, to publications, or to other Website information so long as the link:\n(a) is not in any way misleading;\n(b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services;\n(c) fits within the context of the linking party’s site.",
              ),
              Paragraph(
                "Other organizations wishing to link to our website can email us at info@paktvdramas.pk with their request. We may consider and approve link requests at our sole discretion. Please include your name, your organization name, contact information (such as a phone number and/or email) as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URL(s) on our site to which you would like to link. Please allow 2-3 weeks for a response.",
              ),
              Paragraph(
                "Approved organizations may hyperlink to our Website as follows:\n• By use of our corporate name\n• By use of the uniform resource locator (Web address) being linked to\n• By use of any other description of our Website or material being linked to that makes sense within the context of content on the linking party’s site.",
              ),
              Paragraph(
                "No use of our logo or other artwork will be allowed for linking absent a trademark license agreement.",
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0,left:16.0,right: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}