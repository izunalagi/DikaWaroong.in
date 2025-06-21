import 'package:flutter/material.dart';
import 'package:project/settings/about_us_page.dart';
import 'package:project/settings/contact_us_page.dart';
import 'package:project/settings/faq_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SettingItem> menuItems = [
      _SettingItem('About us', Icons.info_outline, const AboutUsPage()),
      _SettingItem('Contact', Icons.phone_outlined, const ContactUsPage()),
      _SettingItem('FAQs', Icons.help_outline, const FAQPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = menuItems[index];

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              leading: Icon(item.icon, color: Colors.orange),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => item.page!,
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final Widget? page;

  _SettingItem(this.title, this.icon, this.page);
}
