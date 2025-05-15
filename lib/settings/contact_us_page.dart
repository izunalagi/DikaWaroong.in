import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _openMaps() async {
    const url =
        'https://www.google.com/maps/search/?api=1&query=-6.914744,107.609810';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka Google Maps.';
    }
  }

  Widget buildInfoRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Us',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            buildInfoRow(Icons.phone, Colors.green, '+62 812 3456 7890'),
            buildInfoRow(Icons.phone, Colors.green, '+62 813 9876 5432'),
            buildInfoRow(Icons.email, Colors.green, 'support@dikawaroong.in'),
            buildInfoRow(Icons.location_on, Colors.green,
                'Jl. Makan Enak No. 123\nBandung, Indonesia'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _openMaps,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://maps.googleapis.com/maps/api/staticmap?center=-6.914744,107.609810&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7C-6.914744,107.609810&key=YOUR_API_KEY',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
