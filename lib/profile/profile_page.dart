import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Shakibul Islam';
    const userId = '1540580';
    const email = 'shakibul@email.com';
    const phone = '+62 812 3456 7890';
    const address = 'Jl. Makan Enak No. 123\nBandung, Indonesia';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        backgroundColor: Colors.green.shade600,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3'), // Ganti dengan asset jika perlu
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ID: $userId',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _ProfileMenuItem(icon: Icons.local_shipping, label: 'All Order'),
                  _ProfileMenuItem(icon: Icons.card_giftcard, label: 'Voucher'),
                  _ProfileMenuItem(icon: Icons.home, label: 'Address'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Email', value: email),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'No HP', value: phone),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Alamat', value: address),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileMenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.green),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
