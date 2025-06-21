import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  final NumberFormat currencyFormatter = NumberFormat('#,###', 'id_ID');
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkoutNow(CartProvider cart) async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    if (token == null) {
      print('❌ Token tidak ditemukan!');
      return;
    }

    print('📦 JWT: $token');

    try {
      // Ambil data user dari API /me
      final meResponse = await http.get(
        Uri.parse(
          'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/me',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📦 /me Status: ${meResponse.statusCode}');
      print('📦 /me Body: ${meResponse.body}');

      if (meResponse.statusCode != 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal mengambil akun')));
        return;
      }

      final meData = jsonDecode(meResponse.body);
      print('📦 meData: $meData');

      final int akunId = meData['id_Akun']; // sesuai dengan data JSON

      print('✅ akunId: $akunId');

      final transaksiPayload = {
        "akunIdAkun": akunId,
        "statusPesanan": false,
        "tanggal": DateTime.now().toIso8601String(),
      };
      print('📦 Request Transaksi: ${jsonEncode(transaksiPayload)}');

      // Kirim request create transaksi
      final response = await http.post(
        Uri.parse(
          'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Transaksi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(transaksiPayload),
      );

      print('📦 Response Transaksi: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat transaksi')),
        );
        return;
      }

      final transaksiData = jsonDecode(response.body);
      print('📦 transaksiData: $transaksiData');

      final int? transaksiId = transaksiData['id_transaksi'];

      if (transaksiId == null) {
        print('❌ transaksiId null!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendapatkan ID Transaksi')),
        );
        return;
      }

      print('✅ transaksiId: $transaksiId');

      // Kirim detail transaksi satu per satu
      for (var item in cart.items) {
        print(
          '➡️ Kirim detail: idProduk=${item.idProduk}, quantity=${item.quantity}',
        );
        final detailRes = await http.post(
          Uri.parse(
            'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/DetailTransaksi',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'transaksiIdTransaksi': transaksiId,
            'produkIdProduk': item.idProduk,
            'quantity': item.quantity,
          }),
        );

        print('📦 Response Detail: ${detailRes.statusCode}');
        print('📦 Detail Body: ${detailRes.body}');

        if (detailRes.statusCode != 200 && detailRes.statusCode != 201) {
          print('❌ Gagal kirim detail. Status: ${detailRes.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengirim detail transaksi')),
          );
        } else {
          print('✅ Detail berhasil');
        }
      }

      cart.clearCart();
      Navigator.pushNamed(context, '/qris', arguments: transaksiId);
    } catch (e) {
      print('❌ ERROR SAAT CHECKOUT: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.orange.shade600,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang masih kosong.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final animation = Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          (index / cart.items.length),
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                    );

                    final double price = item.price.toDouble();
                    final int quantity = item.quantity;

                    return SlideTransition(
                      position: animation,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          minVerticalPadding: 12,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Qty: $quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp${currencyFormatter.format(price * quantity)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                tooltip: 'Hapus item',
                                onPressed: () {
                                  cart.removeItem(item);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Rp${currencyFormatter.format(cart.totalPrice)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Checkout Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      _checkoutNow(cart);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
