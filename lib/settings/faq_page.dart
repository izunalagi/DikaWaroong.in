import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('Bagaimana cara memesan makanan?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pilih menu yang diinginkan, klik "Tambah ke Keranjang", lalu checkout.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Metode pembayaran apa yang tersedia?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Kami menerima pembayaran melalui QRIS, transfer bank, dan tunai.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Apakah saya bisa membatalkan pesanan?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pesanan hanya bisa dibatalkan sebelum statusnya diproses.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
