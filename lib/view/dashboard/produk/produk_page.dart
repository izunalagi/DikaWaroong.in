import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'edit_produk_page.dart';
import 'tambah_produk_page.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Map<String, dynamic>> produkList = [];

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    const apiUrl =
        'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Produk';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          produkList = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saat fetch data: $e');
    }
  }

  Future<void> deleteProduk(int id) async {
    final apiUrl =
        'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Produk/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        debugPrint("Produk berhasil dihapus");
      } else {
        debugPrint("Gagal menghapus produk: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error saat menghapus produk: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final produk = produkList[index];
          final idProduk = produk['idProduk'];

          return Dismissible(
            key: Key(idProduk.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: Text(
                    "Yakin ingin menghapus ${produk['namaProduk']}?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              final namaProduk = produk['namaProduk'];

              setState(() {
                produkList.removeWhere((item) => item['idProduk'] == idProduk);
              });

              await deleteProduk(idProduk);

              if (!mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$namaProduk dihapus")));
            },
            child: _buildProdukCard(index, produk),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade400,
        onPressed: () async {
          final produkBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahProdukPage()),
          );

          if (!mounted) return;
          if (produkBaru != null) {
            await fetchProduk();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProdukCard(int index, Map<String, dynamic> produk) {
    final formattedPrice = _currencyFormatter.format(produk['harga']);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.orange.shade200),
        ),
        elevation: 3,
        shadowColor: Colors.orange.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 8, right: 4),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: produk['gambar'] != null &&
                      produk['gambar'].toString().isNotEmpty
                  ? Image.network(
                      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/images/${produk['gambar']}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child:
                            const Icon(Icons.broken_image, color: Colors.red),
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
            ),
            title: Text(
              produk['namaProduk'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$formattedPrice | Stok: ${produk['stock']}",
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  produk['kategori']?['namaKategori'] ?? 'Lainnya',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.deepOrange),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProdukPage(produk: produk),
                  ),
                );

                if (!mounted) return;

                if (updated != null) {
                  await fetchProduk();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
