import 'package:flutter/material.dart';
import 'package:uielem/screens/about_screen.dart';
import 'package:uielem/screens/contact_us_screen.dart';
class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
          body:Column(

            children: [
              Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),

                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
                        ),
                      ),

                      // Expanded Widget to center the text
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Help",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Placeholder to keep the text centered even if there’s no trailing icon
                      SizedBox(width: 40), // Adjust width to match the back button's width
                    ],
                  )

              ),
              const SizedBox(height: 20),
              _buildProfileOption(context,Icons.info_outline, "AboutUs", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutScreen()),
                );
              }),
              const Divider(thickness: 1, color: Colors.grey),

              // ➕ Added: Terms & Conditions Link
              _buildProfileOption(context,Icons.contact_page_outlined, "ContactUs", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactUsScreen()),
                );
              }),

              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 20),
            ],

          )
      ),
    );
  }
  Widget _buildProfileOption(BuildContext context,IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: Colors.red, size: 22),
      title:
      Text(
        textAlign:TextAlign.start,
        title,
        style:  Theme.of(context).textTheme.bodyMedium,
      ),

      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

}
