import 'package:flutter/material.dart';
import '../widgets/contact_item.dart';
import '../widgets/contact_section_title.dart';


class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Contact Us", style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactSectionTitle(title: "Connect with us via"),
            ContactItem(
              icon: Icons.email,
              label: "Email",
              value: "info@paktvdramas.pk",
              url: "mailto:info@paktvdramas.pk",
            ),
            ContactItem(
              icon: Icons.camera_alt,
              label: "Instagram",
              value: "paktv.dramas",
              url: "https://www.instagram.com/paktv.dramas/",
            ),
            ContactItem(
              icon: Icons.facebook,
              label: "Facebook",
              value: "Paktvdramas",
              url: "https://www.facebook.com/Paktvdramas-102246518255621",
            ),
            ContactItem(
              icon: Icons.chat,
              label: "Twitter",
              value: "@Paktvdramas1",
              url: "https://twitter.com/Paktvdramas1",
            ),
            ContactItem(
              icon: Icons.ondemand_video,
              label: "YouTube",
              value: "Pak TV Dramas",
              url: "https://www.youtube.com/channel/UCebXriF44ZTpe1nXD8FUN1w",
            ),
            ContactItem(
              icon: Icons.business,
              label: "LinkedIn",
              value: "paktvdramas-pk",
              url: "https://www.linkedin.com/in/paktvdramas-pk-14a636203/",
            ),
          ],
        ),
      ),
    );
  }
}
