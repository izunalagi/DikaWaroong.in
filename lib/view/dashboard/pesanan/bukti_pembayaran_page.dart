import 'package:flutter/material.dart';

class BuktiPembayaranPage extends StatelessWidget {
  final int idTransaksi;

  const BuktiPembayaranPage({super.key, required this.idTransaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukti Pembayaran #$idTransaksi'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Center(
        child: Text(
          'Halaman Bukti Pembayaran\nTransaksi #$idTransaksi',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
