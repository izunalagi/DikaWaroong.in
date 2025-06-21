import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/view/home/ProductDetailsPage.dart';
import 'package:project/view/home/menubycategoryPage.dart';
import 'package:project/widgets/category_card.dart';
import 'package:project/widgets/custom_nav_bar.dart';
import 'package:project/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _galleryList = [];
  bool _isLoading = true;

  final List<String> _menuItems = [
    'About us',
    'Contact',
    'Settings',
    'Sign Out',
  ];

  final String baseImageUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/gallery/'; // Emulator-safe

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
    fetchGallery();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse(
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Kategori',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _categories = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Produk',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _products = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchGallery() async {
    final url = Uri.parse(
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Gallery',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _galleryList = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print("Error fetching gallery: $e");
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
              : CustomScrollView(
                slivers: [
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
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        itemCount: _products.length >= 4 ? 4 : _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          String name = product['namaProduk'] ?? '';
                          String imageUrl =
                              'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/images/${product['gambar']}';
                          final hargaRaw = product['harga'];
                          final price = switch (hargaRaw) {
                            int value => value,
                            double value => value.toInt(),
                            _ => 0,
                          };
                          final formattedPrice = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(price);

                          String kategori =
                              product['kategori']?['namaKategori'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductDetailsPage(
                                        idProduk: product['idProduk'],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
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
                                    formattedPrice,
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child:
                          _categories.isEmpty
                              ? const Center(
                                child: Text("Tidak ada kategori tersedia."),
                              )
                              : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    ..._categories.map((kategori) {
                                      final nama = kategori['namaKategori'];
                                      final imageAsset = _getImageForCategory(
                                        nama,
                                      );

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
                                    }),
                                    const SizedBox(width: 18),
                                  ],
                                ),
                              ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_galleryList.isEmpty)
                            const Center(
                              child: Text("Belum ada gambar di gallery"),
                            )
                          else
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 180,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                              ),
                              items: List.generate(
                                (_galleryList.length / 2).ceil(),
                                (index) {
                                  final first = _galleryList[index * 2];
                                  final second =
                                      index * 2 + 1 < _galleryList.length
                                          ? _galleryList[index * 2 + 1]
                                          : null;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildGalleryImage(first),
                                      const SizedBox(width: 12),
                                      if (second != null)
                                        _buildGalleryImage(second),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildGalleryImage(Map<String, dynamic> item) {
    final imageUrl = baseImageUrl + (item['fotoGallery'] ?? '');
    return GestureDetector(
      onTap: () => _showZoomableImage(context, imageUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
        ),
      ),
    );
  }

  void _showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(8),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 5,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
    );
  }
}
