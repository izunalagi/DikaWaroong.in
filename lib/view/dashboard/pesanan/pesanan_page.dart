import 'package:flutter/material.dart';
import 'detail_transaksi_page.dart';
import 'bukti_pembayaran_page.dart'; // pastikan file ini ada

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  List<Map<String, dynamic>> transaksiList = [
    {
      'id_transaksi': 1,
      'tanggal': '2025-05-15',
      'status': 'Belum Selesai',
      'selesai': false,
      'bukti_uploaded': true, // ✅ contoh sudah upload bukti
    },
    {
      'id_transaksi': 2,
      'tanggal': '2025-05-14',
      'status': 'Belum Selesai',
      'selesai': false,
      'bukti_uploaded': false, // ❌ contoh belum upload
    },
  ];

  void markAsSelesai(int index) {
    setState(() {
      transaksiList[index]['selesai'] = true;
      transaksiList[index]['status'] = 'Selesai';
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pesanan Selesai'),
        content: const Text('Pesanan telah ditandai sebagai selesai.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Pesanan Masuk'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: transaksiList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final transaksi = transaksiList[index];

          return Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.orange.shade200),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaksi #${transaksi['id_transaksi']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tanggal: ${transaksi['tanggal']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Status: ${transaksi['status']}',
                    style: TextStyle(
                      color: transaksi['selesai'] ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Tombol Bukti
                      IconButton(
                        onPressed: transaksi['bukti_uploaded']
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BuktiPembayaranPage(
                                      idTransaksi: transaksi['id_transaksi'],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.receipt_long,
                          color: transaksi['bukti_uploaded']
                              ? Colors.green
                              : Colors.grey,
                          size: 28,
                        ),
                        tooltip: 'Bukti Pembayaran',
                      ),
                      const SizedBox(width: 8),

                      // Tombol Detail
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailTransaksiPage(
                                idTransaksi: transaksi['id_transaksi'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Detail'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Tombol Selesaikan
                      ElevatedButton.icon(
                        onPressed: transaksi['selesai']
                            ? null
                            : () => markAsSelesai(index),
                        icon: const Icon(Icons.check),
                        label: const Text('Selesaikan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: transaksi['selesai']
                              ? Colors.grey
                              : Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
