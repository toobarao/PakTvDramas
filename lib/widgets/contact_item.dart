import 'package:flutter/material.dart';
import '../utilities/url_launch.dart';


class ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;

  const ContactItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
