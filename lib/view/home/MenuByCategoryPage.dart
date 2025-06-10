import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/view/home/ProductDetailsPage.dart';

class MenuByCategoryPage extends StatefulWidget {
  final String category;
  const MenuByCategoryPage({super.key, required this.category});

  @override
  State<MenuByCategoryPage> createState() => _MenuByCategoryPageState();
}

class _MenuByCategoryPageState extends State<MenuByCategoryPage> {
  List<dynamic> menuList = [];
  bool isLoading = true;
  final String baseImageUrl = 'https://localhost:7138/images/';

  @override
  void initState() {
    super.initState();
    fetchProdukByCategory();
  }

  Future<void> fetchProdukByCategory() async {
    final url = Uri.parse('https://localhost:7138/api/Produk');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final filtered =
            data.where((item) {
              final kategori = item['kategori'];
              final namaKategori =
                  kategori != null ? kategori['namaKategori'] : '';
              return namaKategori.toString().toLowerCase() ==
                  widget.category.toLowerCase();
            }).toList();

        setState(() {
          menuList = filtered;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load produk');
      }
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori: ${widget.category}'),
        backgroundColor: Colors.orange.shade600,
        elevation: 4,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : menuList.isEmpty
              ? const Center(child: Text('Tidak ada produk pada kategori ini.'))
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: menuList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuList[index];
                    final harga = item['harga'] ?? 0;
                    final imageUrl = baseImageUrl + (item['gambar'] ?? '');
                    return _MenuItemCard(
                      name: item['namaProduk'] ?? '',
                      image: imageUrl,
                      price: harga,
                      description: item['keterangan'] ?? '-',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsPage(
                                  idProduk: item['idProduk'], // ✅ fix added
                                  name: item['namaProduk'],
                                  image: imageUrl,
                                  price: harga,
                                  description: item['keterangan'] ?? '-',
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String description;
  final VoidCallback onTap;

  const _MenuItemCard({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  String formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: Colors.orange.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                image,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                formatRupiah(price),
                style: const TextStyle(fontSize: 15, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
