import 'package:flutter/material.dart';
import 'package:project/view/home/ProductDetailsPage.dart';

class MenuByCategoryPage extends StatefulWidget {
  final String category;
  const MenuByCategoryPage({super.key, required this.category});

  @override
  State<MenuByCategoryPage> createState() => _MenuByCategoryPageState();
}

class _MenuByCategoryPageState extends State<MenuByCategoryPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = menuList
        .where((item) => item['category'] == widget.category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori: ${widget.category}'),
        backgroundColor: Colors.orange.shade600,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: filteredList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final item = filteredList[index];
            final animationDelay = index * 100;

            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                double animationValue = _animation.value;
                double opacity = animationValue.clamp(0, 1);
                double scale = 0.8 + (animationValue * 0.2);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: _MenuItemCard(
                item: item,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: ProductDetailsPage(
                            name: item['name']!,
                            image: item['image']!,
                            price: int.parse(item['price']!),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final Map<String, String> item;
  final VoidCallback onTap;

  const _MenuItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isBestSeller = item['bestSeller'] == 'true';
    final hasDiscount = item['originalPrice'] != null && item['originalPrice']!.isNotEmpty;
    final originalPrice = hasDiscount ? int.tryParse(item['originalPrice']!) ?? 0 : 0;
    final currentPrice = int.tryParse(item['price']!) ?? 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: Colors.orange.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.orange.withOpacity(0.2),
        highlightColor: Colors.orange.withOpacity(0.1),
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
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder.png',
                    image: item['image']!,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Container(
                      width: double.infinity,
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                if (isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Terlaris',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
              child: Text(
                item['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Rp ${currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (hasDiscount)
                    const SizedBox(width: 8),
                  if (hasDiscount)
                    Text(
                      'Rp ${originalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 14,
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
  }
}



final List<Map<String, String>> menuList = [
  {
    'name': 'Ayam bakar + nasi',
    'price': '18900',
    
    'image': 'assets/images/ayamkecap.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
  },
  {
    'name': 'Ayam goreng kremes sambel geprek + nasi',
    'price': '18900',
    
    'image': 'assets/images/ayamgeprek.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
  },
  {
    'name': 'Ayam goreng kremes sambal ijo + nasi',
    'price': '18900',
    
    'image': 'assets/images/ayamcabeijo.jpg',
    'category': 'Makanan Berat',
    'weight': '250g',
    'bestSeller': 'true',
  },
  {
    'name': 'Ayam bakar sambal ijo tanpa nasi',
    'price': '15900',
    'originalPrice': '16900',
    'image': 'assets/images/alpukat.jpg',
    'category': 'Minuman',
    'weight': '220g',
  },
];
