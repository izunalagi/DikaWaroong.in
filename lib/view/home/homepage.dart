import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/view/home/ProductDetailsPage.dart';
import 'package:project/view/home/menubycategoryPage.dart';
import 'package:project/settings/setting_page.dart';
import 'package:project/view/home/cartPage.dart';
import 'package:project/models/product.dart';
import 'package:project/widgets/custom_nav_bar.dart';
import 'package:project/widgets/category_card.dart';
import 'package:project/widgets/custom_app_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Product> popularProducts = [
    Product(
      name: 'Seblak',
      description: 'Seblak pedas nikmat khas Bandung.',
      image: 'assets/images/seblak.jpeg',
      price: 35000,
      originalPrice: 45000,
      quantity: 1,
    ),
    Product(
      name: 'Ayam Kecap',
      description: 'Ayam lezat dengan bumbu kecap manis.',
      image: 'assets/images/ayamkecap.jpg',
      price: 40000,
      originalPrice: 50000,
      quantity: 1,
    ),
    Product(
      name: 'Alpukat Coklat',
      description: 'Minuman segar dari alpukat dan coklat.',
      image: 'assets/images/alpukat.jpg',
      price: 20000,
      originalPrice: 25000,
      quantity: 1,
    ),
    Product(
      name: 'Kentang Goreng',
      description: 'Cemilan renyah dengan saus keju.',
      image: 'assets/images/kentang.jpg',
      price: 18000,
      originalPrice: 22000,
      quantity: 1,
    ),
  ];

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

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
            .toList(),
      );

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    title: Text(item),
                    onTap: () => Navigator.pop(context),
                  ))
              .toList(),
        ),
      );

  Widget _buildBody() {
    return SafeArea(
      child: Column(
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
                      items: [
                        'assets/images/iklan.jpeg',
                        'assets/images/iklan2.jpeg',
                        'assets/images/iklan3.jpeg',
                      ].map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Makan Populer',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('View All'),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: popularProducts.length,
                      itemBuilder: (context, index) {
                        final product = popularProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  name: product.name,
                                  image: product.image,
                                  price: product.price,
                                  
                                  
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
                                Expanded(
                                  child: Image.asset(product.image,
                                      fit: BoxFit.contain),
                                ),
                                const SizedBox(height: 8),
                                Text(product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text('Level 1, level 2'),
                                Text('Rp ${product.price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          CategoryCard(
                            label: 'Makanan Berat',
                            imagePath: 'assets/images/makanan.jpeg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MenuByCategoryPage(category: 'Makanan Berat'),
                                ),
                              );
                            },
                          ),
                          CategoryCard(
                            label: 'Minuman',
                            imagePath: 'assets/images/minuman.jpeg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MenuByCategoryPage(category: 'Minuman'),
                                ),
                              );
                            },
                          ),
                          CategoryCard(
                            label: 'Snacks',
                            imagePath: 'assets/images/snacks.jpeg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MenuByCategoryPage(category: 'Snacks'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 18),
                        ],
                      ),
                    ),
                  ),
                ),




                // Rekomendasi Pelanggan
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Rekomendasi Pelanggan',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Lihat Semua'),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final resto = restoranList[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  name: resto['name'],
                                  image: resto['image'],
                                  price: resto['price'],
                                  
                                  
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    resto['image'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(resto['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text('⭐ ${resto['rating']}'),
                                        Text('🚚 ${resto['eta']}'),
                                        const SizedBox(height: 4),
                                        Text(resto['promo'],
                                            style: const TextStyle(
                                                color: Colors.red)),
                                        Text(resto['minOrder'],
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: restoranList.length,
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

final List<String> _menuItems = ['About us', 'Contact', 'Settings', 'Sign Out'];

class CartIcon extends StatelessWidget {
  const CartIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      },
    );
  }
}

enum Menu { itemOne, itemTwo, itemThree }

class CategoryIconChip extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryIconChip({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.orange.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> restoranList = [
  {
    'name': 'Pecal',
    'rating': '4.7 (3rb+)',
    'eta': 'Mulai dari 25 menit',
    'promo': 'Diskon 40%',
    'minOrder': 'Min. transaksi Rp75.000',
    'image': 'assets/images/pecel.jpeg',
    'category': 'Makanan Berat',
    'price': 42000,
    'originalPrice': 50000,
  },
  {
    'name': 'Warung seva99 - Kepatihan',
    'rating': '4.5 (1rb+)',
    'eta': 'Mulai dari 35 menit',
    'promo': 'Diskon 40%',
    'minOrder': 'Min. transaksi Rp79.000',
    'image': 'assets/images/minuman.jpeg',
    'category': 'Minuman',
    'price': 18000,
    'originalPrice': 22000,
  },
  {
    'name': 'Lalapan Mbak Umi & Es Teler 67',
    'rating': '4.8 (2rb+)',
    'eta': 'Mulai dari 25 menit',
    'promo': 'Diskon 40%',
    'minOrder': 'Min. transaksi Rp79.000',
    'image': 'assets/images/jamur.jpeg',
    'category': 'Snacks',
    'price': 15000,
    'originalPrice': 19000,
  },
];
