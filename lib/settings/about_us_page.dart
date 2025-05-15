import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'DikaWaroong.in adalah aplikasi kuliner yang menyediakan berbagai makanan dan minuman khas Indonesia.\n\n'
          'Kami berkomitmen untuk menyajikan menu yang lezat, berkualitas, dan harga terjangkau untuk semua pelanggan.\n\n'
          'Terima kasih telah mempercayai kami sebagai teman kuliner Anda!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
