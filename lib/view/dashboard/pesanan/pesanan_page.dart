import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_transaksi_page.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  List<Map<String, dynamic>> transaksiList = [];
  bool isLoading = true;
  String? errorMessage;

  final String apiUrl = 'https://localhost:7138/api/Transaksi';

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  Future<void> fetchTransaksi() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/with-akun'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Ambil bukti transfer untuk setiap transaksi
        final List<Map<String, dynamic>> enrichedData = [];
        for (var item in data) {
          final mapItem = Map<String, dynamic>.from(item);
          final idTransaksi = mapItem['idTransaksi'];

          try {
            final buktiResponse = await http.get(
              Uri.parse('$apiUrl/$idTransaksi/bukti'),
            );
            if (buktiResponse.statusCode == 200) {
              final buktiData = jsonDecode(buktiResponse.body);
              // Simpan URL lengkap bukti transfer
              mapItem['buktiURL'] = buktiData['url'];
              mapItem['buktiUploaded'] = true;
            } else {
              mapItem['buktiURL'] = null;
              mapItem['buktiUploaded'] = false;
            }
          } catch (e) {
            mapItem['buktiURL'] = null;
            mapItem['buktiUploaded'] = false;
          }

          enrichedData.add(mapItem);
        }

        setState(() {
          transaksiList = enrichedData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<void> markAsSelesai(int index) async {
    final id = transaksiList[index]['idTransaksi'];
    try {
      final response = await http.put(Uri.parse('$apiUrl/$id/selesaikan'));

      if (response.statusCode == 200) {
        setState(() {
          transaksiList[index]['selesai'] = true;
          transaksiList[index]['status'] = 'Selesai';
        });

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Pesanan Selesai'),
                content: const Text('Pesanan telah ditandai sebagai selesai.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyelesaikan pesanan. Status: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : transaksiList.isEmpty
              ? const Center(child: Text('Belum ada transaksi.'))
              : ListView.builder(
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
                            'Transaksi #${transaksi['idTransaksi']}',
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
                            'User: ${transaksi['username']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Status: ${transaksi['status']}',
                            style: TextStyle(
                              color:
                                  transaksi['selesai']
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed:
                                    transaksi['buktiUploaded']
                                        ? () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  title: const Text(
                                                    'Bukti Pembayaran',
                                                  ),
                                                  content:
                                                      transaksi['buktiURL'] !=
                                                              null
                                                          ? Image.network(
                                                            transaksi['buktiURL']!,
                                                            fit: BoxFit.contain,
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) => const Text(
                                                                  'Gagal memuat gambar',
                                                                ),
                                                          )
                                                          : const Text(
                                                            'Bukti tidak tersedia',
                                                          ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Tutup',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                        : null,
                                icon: Icon(
                                  Icons.receipt_long,
                                  color:
                                      transaksi['buktiUploaded']
                                          ? Colors.green
                                          : Colors.grey,
                                  size: 28,
                                ),
                                tooltip: 'Lihat Bukti Pembayaran',
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => DetailTransaksiPage(
                                            idTransaksi:
                                                transaksi['idTransaksi'],
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
                              ElevatedButton.icon(
                                onPressed:
                                    transaksi['selesai']
                                        ? null
                                        : () => markAsSelesai(index),
                                icon: const Icon(Icons.check),
                                label: const Text('Selesaikan'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      transaksi['selesai']
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
