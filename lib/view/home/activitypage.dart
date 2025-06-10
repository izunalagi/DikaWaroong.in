import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/widgets/custom_nav_bar.dart';
import 'package:project/widgets/custom_app_bar.dart';
import 'package:project/view/home/DetailPesananPage.dart';
import 'package:project/view/home/qris_payment_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final storage = const FlutterSecureStorage();
  final currencyFormat = NumberFormat.simpleCurrency(
    locale: 'id',
  ); // simbol Rp otomatis
  List<Map<String, dynamic>> transaksiList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadActivityData();
  }

  Future<void> _loadActivityData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await storage.read(key: 'jwt');
      if (token == null) {
        setState(() {
          errorMessage = 'Token tidak ditemukan, silakan login ulang.';
          isLoading = false;
        });
        print('❌ Token tidak ditemukan.');
        return;
      }
      print('🔑 Token ditemukan.');

      // Ambil info user
      final meRes = await http.get(
        Uri.parse('https://localhost:7138/api/Auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (meRes.statusCode != 200) {
        throw 'Gagal mengambil data user. Status code: ${meRes.statusCode}';
      }
      print('👤 Data user berhasil diambil.');

      final Map<String, dynamic> meData = jsonDecode(meRes.body);
      print('User data: $meData');

      final akunId = meData['id_Akun'] ?? meData['id_akun'] ?? meData['id'];
      if (akunId == null) {
        throw 'User ID (akunId) tidak ditemukan di data user.';
      }
      print('User ID: $akunId');

      // Ambil semua transaksi
      final transaksiRes = await http.get(
        Uri.parse('https://localhost:7138/api/Transaksi'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (transaksiRes.statusCode != 200) {
        throw 'Gagal mengambil data transaksi. Status code: ${transaksiRes.statusCode}';
      }
      print('📄 Data transaksi berhasil diambil.');

      final List transaksiData = jsonDecode(transaksiRes.body);
      print('Transaksi total: ${transaksiData.length} item');

      final List<Map<String, dynamic>> userTransaksi = [];

      for (var trx in transaksiData) {
        print('Cek transaksi: $trx');

        // Beberapa backend mungkin punya key berbeda, coba cek kemungkinan lainnya
        final trxAkunId =
            trx['akunIdAkun'] ?? trx['akun_id_akun'] ?? trx['akunId'];
        if (trxAkunId == null) {
          print('⚠️ transaksi tanpa akunIdAkun, dilewati.');
          continue;
        }
        if (trxAkunId.toString() != akunId.toString()) {
          print('⚠️ transaksi bukan milik user ini, dilewati.');
          continue;
        }

        final trxId = trx['id_transaksi'] ?? trx['idTransaksi'] ?? trx['id'];
        if (trxId == null) {
          print('⚠️ transaksi tanpa id_transaksi, dilewati.');
          continue;
        }

        final tanggalStr = trx['tanggal'] ?? trx['tanggalTransaksi'];
        final tanggal = DateTime.tryParse(tanggalStr ?? '');
        if (tanggal == null) {
          print('⚠️ tanggal transaksi invalid, dilewati.');
          continue;
        }
        final formattedDate = DateFormat(
          'dd MMM yyyy',
          'id_ID',
        ).format(tanggal);

        // Ambil total harga
        final totalRes = await http.get(
          Uri.parse('https://localhost:7138/api/DetailTransaksi/total/$trxId'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (totalRes.statusCode != 200) {
          print(
            '⚠️ Gagal ambil total harga transaksi $trxId, status code: ${totalRes.statusCode}',
          );
          continue;
        }
        final totalHargaData = jsonDecode(totalRes.body);
        final totalHarga = totalHargaData['total_harga'];
        if (totalHarga == null) {
          print('⚠️ total_harga null untuk transaksi $trxId');
          continue;
        }

        userTransaksi.add({
          'id': trxId,
          'tanggal': formattedDate,
          'total': totalHarga,
          'status': trx['statusPesanan'] ?? trx['status_pesanan'],
        });
      }

      setState(() {
        transaksiList = userTransaksi;
        isLoading = false;
        errorMessage = null;
      });
      print(
        '✅ Data transaksi user berhasil dimuat: ${userTransaksi.length} item.',
      );
    } catch (e, st) {
      print('❌ Error saat load data transaksi: $e');
      print(st);
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Aktivitas Pesanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (transaksiList.isEmpty)
            const Expanded(child: Center(child: Text('Belum ada transaksi')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: transaksiList.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  final item = transaksiList[index];
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + index * 100),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Transaksi #${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['tanggal'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['status'] == true
                                            ? 'Status: Selesai'
                                            : 'Status: Sedang Diproses',
                                        style: TextStyle(
                                          color:
                                              item['status'] == true
                                                  ? Colors.green
                                                  : Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rp${NumberFormat('#,###', 'id_ID').format(item['total'])}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.tealAccent.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailPesananPage(
                                              idTransaksi: item['id'],
                                              nomorUrut: index + 1,
                                            ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text('Lihat Detail'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => QrisPaymentPage(
                                              idTransaksi: item['id'],
                                            ),
                                      ),
                                    );
                                    _loadActivityData(); // refresh data setelah balik dari QRIS page
                                  },

                                  icon: const Icon(Icons.receipt),
                                  label: const Text("Upload Bukti"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
