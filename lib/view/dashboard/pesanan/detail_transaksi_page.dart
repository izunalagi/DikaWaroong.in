import 'package:flutter/material.dart';

class DetailTransaksiPage extends StatelessWidget {
  final int idTransaksi;

  const DetailTransaksiPage({super.key, required this.idTransaksi});

  // Dummy data
  final List<Map<String, dynamic>> detailList = const [
    {
      'id_detail_transaksi': 1,
      'produk': 'Produk A',
      'quantity': 2,
    },
    {
      'id_detail_transaksi': 2,
      'produk': 'Produk B',
      'quantity': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text('Detail Transaksi #$idTransaksi'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: detailList.length,
        itemBuilder: (context, index) {
          final detail = detailList[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail['produk'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Jumlah: ${detail['quantity']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
