import 'package:flutter/material.dart';
import 'package:project/view/home/ProductDetailsPage.dart';

class MenuByCategoryPage extends StatelessWidget {
  final String category;
  const MenuByCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filteredList = menuList
        .where((item) => item['category'] == category)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Kategori: $category')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final item = filteredList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    name: item['name']!,
                    image: item['image']!,
                    price: int.parse(item['price']!),
                    
                    
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
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          item['image']!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (item['bestSeller'] == 'true')
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Terlaris',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      item['name']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'Rp ${item['price']}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        if (item['originalPrice'] != null)
                          Text(
                            'Rp ${item['originalPrice']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}

final List<Map<String, String>> menuList = [
  {
    'name': 'Ayam bakar + nasi',
    'price': '18900',
    'originalPrice': '20900',
    'image': 'assets/images/ayam_bakar_nasi.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
  },
  {
    'name': 'Ayam goreng kremes sambel geprek + nasi',
    'price': '18900',
    'originalPrice': '20900',
    'image': 'assets/images/ayam_geprek_kremes.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
  },
  {
    'name': 'Ayam goreng kremes sambal ijo + nasi',
    'price': '18900',
    'originalPrice': '20900',
    'image': 'assets/images/ayam_kremes_ijo.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
    'bestSeller': 'true',
  },
  {
    'name': 'Ayam bakar sambal ijo tanpa nasi',
    'price': '15900',
    'originalPrice': '16900',
    'image': 'assets/images/ayam_bakar_ijo.jpg',
    'category': 'Makanan Berat',
    'weight': '220g',
  },
];
