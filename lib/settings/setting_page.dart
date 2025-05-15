import 'package:flutter/material.dart';
import 'package:project/settings/about_us_page.dart';
import 'package:project/settings/contact_us_page.dart';
import 'package:project/settings/faq_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final List<String> _menuItems = const ['About us', 'Contact', 'FAQs', 'Sign Out'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_menuItems[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              switch (_menuItems[index]) {
                case 'About us':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsPage()));
                  break;
                case 'Contact':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsPage()));
                  break;
                case 'FAQs':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FAQPage()));
                  break;
                case 'Sign Out':
                  _showSignOutDialog(context);
                  break;
              }
            },
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login'); // Ganti sesuai routing login kamu
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
