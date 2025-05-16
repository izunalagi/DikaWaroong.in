import 'package:flutter/material.dart';
import 'package:project/widgets/custom_nav_bar.dart';
import 'package:project/widgets/custom_app_bar.dart'; // pastikan import ini sesuai path

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  final List<Map<String, String>> activityData = const [
    {
      'title': 'Nasi Goreng Spesial',
      'date': '14 Mei 2025, 18:42',
      'price': 'Rp17.000',
    },
    {
      'title': 'Es Teh Manis',
      'date': '14 Mei 2025, 18:43',
      'price': 'Rp5.000',
    },
    {
      'title': 'Mie Ayam Bakso',
      'date': '13 Mei 2025, 12:10',
      'price': 'Rp15.000',
    },
    {
      'title': 'Ayam Geprek + Nasi',
      'date': '12 Mei 2025, 19:30',
      'price': 'Rp18.000',
    },
    {
      'title': 'Es Jeruk Segar',
      'date': '12 Mei 2025, 19:32',
      'price': 'Rp6.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // ← ganti AppBar standar jadi CustomAppBar
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Aktivitas Pesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: activityData.length,
              itemBuilder: (context, index) {
                final item = activityData[index];
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + index * 100),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.fastfood, color: Colors.deepOrange),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['date']!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.star_border, size: 18),
                                label: const Text("Rate"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade50,
                                  foregroundColor: Colors.orange,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text("Reorder"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade50,
                                  foregroundColor: Colors.green,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
