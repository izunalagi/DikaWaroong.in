import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/view/home/ProductDetailsPage.dart';
import 'package:project/view/home/menubycategoryPage.dart';
import 'package:project/widgets/category_card.dart';
import 'package:project/widgets/custom_nav_bar.dart';
import 'package:project/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _categories = [];
  Future<void> fetchCategories() async {
    final url = Uri.parse('https://localhost:7138/api/Kategori');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _categories = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  String _getImageForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'makanan':
        return 'assets/images/makanan.jpeg';
      case 'minuman':
        return 'assets/images/minuman.jpeg';
      case 'snacks ':
        return 'assets/images/snacks.jpeg';
      default:
        return 'assets/images/default.jpeg';
    }
  }

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  final List<String> _menuItems = [
    'About us',
    'Contact',
    'Settings',
    'Sign Out',
  ];

  final String baseImageUrl = 'https://localhost:7138/images/';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://localhost:7138/api/Produk');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _products = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: isLargeScreen ? null : _drawer(),
      body: _buildBody(),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          switch (index) {
            case 1:
              Navigator.pushReplacementNamed(context, '/activity');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _drawer() => Drawer(
    child: ListView(
      children:
          _menuItems
              .map(
                (item) => ListTile(
                  title: Text(item),
                  onTap: () => Navigator.pop(context),
                ),
              )
              .toList(),
    ),
  );

  Widget _buildBody() {
    return SafeArea(
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        // Carousel
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 160,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                              ),
                              items:
                                  [
                                    'assets/images/iklan.jpeg',
                                    'assets/images/iklan2.jpeg',
                                    'assets/images/iklan3.jpeg',
                                  ].map((imagePath) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image.asset(
                                              imagePath,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),

                        // Makan Populer
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Rekomendasi Menu',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('View All'),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 270,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  _products.length >= 4 ? 4 : _products.length,
                              itemBuilder: (context, index) {
                                final product = _products[index];
                                String name = product['namaProduk'] ?? '';
                                String imageUrl =
                                    baseImageUrl + (product['gambar'] ?? '');
                                int price = product['harga'] ?? 0;
                                String kategori =
                                    product['kategori']?['namaKategori'] ?? '';

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProductDetailsPage(
                                              name: name,
                                              image: imageUrl,
                                              price: price,
                                              description:
                                                  product['keterangan'] ?? '',
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons.broken_image,
                                                  size: 80,
                                                  color: Colors.grey,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(kategori),
                                        Text(
                                          'Rp $price',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Kategori
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child:
                                _categories.isEmpty
                                    ? const Center(
                                      child: Text(
                                        "Tidak ada kategori tersedia.",
                                      ),
                                    )
                                    : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Row(
                                        children: [
                                          ..._categories.map((kategori) {
                                            final nama =
                                                kategori['namaKategori'];
                                            final imageAsset =
                                                _getImageForCategory(nama);

                                            return CategoryCard(
                                              label: nama,
                                              imagePath: imageAsset,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            MenuByCategoryPage(
                                                              category: nama,
                                                            ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                          const SizedBox(
                                            width: 18,
                                          ), // tambahkan sebagai widget biasa
                                        ]..add(
                                          const SizedBox(width: 18),
                                        ), // spacing terakhir
                                      ),
                                    ),
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
