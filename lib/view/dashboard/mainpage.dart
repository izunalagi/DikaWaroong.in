import 'package:flutter/material.dart';
import 'produk/produk_page.dart';
import 'gallery/gallery_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      drawer: Drawer(
        child: Container(
          color: Colors.orange.shade100,
          child: ListView(
            padding: EdgeInsets.zero,
              children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.orange.shade300),
                child: const Center(
                  child: Text(
                    'Menu Utama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                debugPrint('Navigasi ke Dashboard');
              }),
              _buildDrawerItem(Icons.shopping_bag, 'Produk', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                );
              }),
              _buildDrawerItem(Icons.category, 'Kategori', () {}),
              _buildDrawerItem(Icons.inbox, 'Pesanan Masuk', () {}),
              _buildDrawerItem(Icons.photo_library, 'Gallery', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryPage()),
                );
              }),              
              // _buildDrawerItem(Icons.person, 'Profil', () {}),
              // _buildDrawerItem(Icons.settings, 'Pengaturan', () {}),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(24),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Image.asset(
                        'assets/images/warung.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Selamat Datang di Dashboard!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Senang melihatmu kembali!',
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}


