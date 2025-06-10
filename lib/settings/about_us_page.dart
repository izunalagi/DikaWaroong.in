import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text('Tentang Kami'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),


            const SizedBox(height: 24),

            // Card dengan isi konten
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/warung.png'), // Ganti sesuai path logo
                      ),
                      const SizedBox(height: 20),

                      // Judul
                      const Text(
                        'DikaWaroong.in',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Isi teks
                      const Text(
                        'DikaWaroong.in adalah aplikasi kuliner yang menyediakan berbagai makanan dan minuman khas Indonesia.\n\n'
                        'Kami berkomitmen untuk menyajikan menu yang lezat, berkualitas tinggi, serta harga yang tetap terjangkau bagi semua pelanggan.\n\n'
                        'Terima kasih telah mempercayai kami sebagai teman kuliner Anda. Kepuasan Anda adalah semangat kami dalam terus berkembang.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
