import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/view/dashboard/kategori/kategori_page.dart';
import 'produk/produk_page.dart';
import 'gallery/gallery_page.dart';
import 'pesanan/pesanan_page.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/dashboard/contact/TambahEditLokasiPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _storage = FlutterSecureStorage();
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

  Future<void> _showLogoutConfirmation() async {
    Navigator.of(context).pop(); // Tutup drawer
    await Future.delayed(const Duration(milliseconds: 300));

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari akun Anda?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      // Hapus JWT token dari secure storage
      await _storage.delete(key: 'jwt');

      if (!mounted) return;

      // Navigasi ke halaman login dan hapus semua route sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
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
                  MaterialPageRoute(builder: (_) => const ProdukPage()),
                );
              }),
              _buildDrawerItem(Icons.category, 'Kategori', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KategoriPage()),
                );
              }),
              _buildDrawerItem(Icons.inbox, 'Pesanan Masuk', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PesananPage()),
                );
              }),
              _buildDrawerItem(Icons.photo_library, 'Gallery', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryPage()),
                );
              }),
              _buildDrawerItem(Icons.photo_library, 'Contact', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TambahEditLokasiPage(),
                  ),
                );
              }),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _showLogoutConfirmation,
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
        Navigator.pop(context); // tutup drawer
        onTap(); // navigasi ke halaman
      },
    );
  }
}
