import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPesananPage extends StatefulWidget {
  final int idTransaksi;
  final int nomorUrut;

  const DetailPesananPage({
    super.key,
    required this.idTransaksi,
    required this.nomorUrut,
  });

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  List<Map<String, dynamic>> detailList = [];
  int totalHarga = 0;
  bool isLoading = true;
  String? errorMessage;

  final String baseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api';

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final detailUrl =
        '$baseUrl/DetailTransaksi/by-transaksi/${widget.idTransaksi}';
    final totalUrl = '$baseUrl/DetailTransaksi/total/${widget.idTransaksi}';

    try {
      final detailResponse = await http.get(Uri.parse(detailUrl));
      final totalResponse = await http.get(Uri.parse(totalUrl));

      if (detailResponse.statusCode == 200 && totalResponse.statusCode == 200) {
        final detailData = jsonDecode(detailResponse.body) as List<dynamic>;
        final totalData = jsonDecode(totalResponse.body);

        setState(() {
          detailList =
              detailData.map((e) => e as Map<String, dynamic>).toList();
          totalHarga = totalData['total_harga'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat data detail transaksi.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pesanan #${widget.nomorUrut}', // Judul statis berdasarkan urutan
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
              : detailList.isEmpty
              ? const Center(child: Text('Detail pesanan kosong.'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: detailList.length,
                      itemBuilder: (context, index) {
                        final detail = detailList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                Text('Harga: Rp${detail['harga']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100.withOpacity(0.4),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Rp$totalHarga',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
