import 'package:flutter/material.dart';
import 'package:project/widgets/custom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Bessie Cooper';
    const email = 'cooper33@hotmail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Avatar, Name, Email
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Stats Box (Pesanan Hari Ini, Dalam Proses, Total Pesanan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatBox("3", "Hari Ini", color: Colors.orange),
                  _buildStatBox("2", "Diproses", color: Colors.amber),
                  _buildStatBox("42", "Total", color: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Menu Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: const [
                  _MenuItem(
                    icon: Icons.person,
                    title: "Username",
                    subtitle: "@cooper_bessie",
                  ),
                  _MenuItem(
                    icon: Icons.email,
                    title: "Email",
                    subtitle: "cooper33@hotmail.com",
                  ),
                  _MenuItem(
                    icon: Icons.lock,
                    title: "Ubah Password",
                    subtitle: "Ganti sandi akun",
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: "Bantuan",
                    subtitle: "Pusat bantuan & FAQ",
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    title: "Keluar",
                    subtitle: "Logout dari akun",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/activity');
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatBox(String number, String label, {required Color color}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: 95,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade50,
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Tambahkan logika navigasi jika diperlukan
        },
      ),
    );
  }
}
