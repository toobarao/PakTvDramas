import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:   Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.grey[900]:Colors.white,
        body: SingleChildScrollView(
          child:Column(
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
                  "Privacy Policy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                // Spacer to balance the Row
                const Spacer(),
              ],
            ),
          ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset('assets/images/PakTvDramaLogo.png',height: 60,alignment: Alignment.center,),
              ),
            ),
            SectionText(
              'This website www.paktvdramas.com (the “Website”) is brought to you by Media Info Systems (Private) Limited (“Company”). '
                  'Company takes the privacy of its Website users (i.e. you) very seriously...'
                  'By using this website, you hereby consent to the data / information gathering practices used by company. Furthermore, '
                  'by using the Website, you hereby agree that this Privacy Policy constitutes a binding agreement...',
            ),
            SectionTitle('PERSONAL INFORMATION/DATA COMPANY MAY COLLECT'),
            SubSectionTitle('INFORMATION THAT DIRECTLY IDENTIFIES YOU:'),
            SectionText(
              'This may include your name, age, sex, address, email address, username, and password.',
            ),
            SubSectionTitle('INFORMATION THAT INDIRECTLY IDENTIFIES YOU:'),
            SectionText(
              'This includes IP address, device ID, time zone, location data, operating system, and links you interact with...',
            ),
            SubSectionTitle('LOCATION DATA:'),
            SectionText(
              'We may collect geo-data and language or country preferences...',
            ),
            SubSectionTitle('PROFILE DATA:'),
            SectionText(
              'This includes your username, interests, feedback, comments, and other user-generated data...',
            ),
            SubSectionTitle('MARKETING AND COMMUNICATIONS DATA:'),
            SectionText(
              'This includes newsletter subscriptions and your marketing preferences.',
            ),
            SubSectionTitle('TRANSACTION AND FINANCIAL DATA:'),
            SectionText(
              'Includes payment and transaction information from our services or affiliate links.',
            ),
            SubSectionTitle('SPECIAL CATEGORY DATA:'),
            SectionText(
              'May include sensitive personal data like religious or political views when given with explicit consent.',
            ),
            SectionTitle('AGGREGATED DATA'),
            SectionText(
              'We combine and anonymize user data to analyze trends, improve services, and support our business model...',
            ),
            SectionTitle('COLLECTION OF PERSONAL DATA / INFORMATION'),
            SectionText(
              'We collect your data through direct interaction, cookies, third-party partners, and social media accounts...',
            ),
            SectionTitle('USE OF YOUR PERSONAL DATA / INFORMATION'),
            SectionText(
              'We use your data for legitimate business purposes, service provision, analytics, communication, marketing...',
            ),
            SectionTitle('MARKETING'),
            SectionText(
              'We may share your data with business partners to inform you about offers, promotions, and content.',
            ),
            SectionTitle('DISCLOSURE OF YOUR PERSONAL DATA'),
            SectionText(
              'We may share your data with affiliates, service providers, third parties, law enforcement, or due to legal obligation...',
            ),
            SectionTitle('KEEPING YOUR DATA SECURE'),
            SectionText(
              'We implement security measures and confidentiality agreements, but cannot fully guarantee internet security...',
            ),
            SectionTitle('MONITORING'),
            SectionText(
              'We may monitor communications for training, compliance, and fraud prevention.',
            ),
            SectionTitle('INFORMATION ABOUT OTHER INDIVIDUALS'),
            SectionText(
              'If you provide data on someone else’s behalf, you confirm you have their consent...',
            ),
            SectionTitle('RETAINING YOUR PERSONAL DATA'),
            SectionText(
              'We keep your data as long as necessary, considering sensitivity and legal requirements. We may anonymize data for research...',
            ),
            SizedBox(height: 32)
            ])
      
      

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
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0,left: 10.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SubSectionTitle extends StatelessWidget {
  final String text;
  const SubSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0,left: 10.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }
}
