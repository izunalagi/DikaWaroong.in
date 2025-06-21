import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailTransaksiPage extends StatefulWidget {
  final int idTransaksi;

  const DetailTransaksiPage({super.key, required this.idTransaksi});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  List<Map<String, dynamic>> detailList = [];
  int totalHarga = 0;
  bool isLoading = true;
  String? errorMessage;

  final String baseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api';

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

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
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text('Detail Transaksi #${widget.idTransaksi}'),
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
              : detailList.isEmpty
              ? const Center(child: Text('Detail transaksi kosong.'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
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
                                Text(
                                  'Harga: ${currencyFormat.format(detail['harga'])}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harga:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currencyFormat.format(totalHarga),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
