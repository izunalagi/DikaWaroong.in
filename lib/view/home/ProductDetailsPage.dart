import 'package:flutter/material.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/models/cartItem.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final int price;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final int totalPrice = widget.price * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black87),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(widget.image, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Price and quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp $totalPrice',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(quantity.toString(),
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Product Description
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Product Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ini adalah deskripsi produk. Makanan ini sangat enak dan cocok untuk semua kalangan. Nikmati rasanya sekarang juga!',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),

      // Add to Cart Button only
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final cartItem = CartItem(
                  name: widget.name,
                  image: widget.image,
                  price: widget.price,
                  quantity: quantity,
                );

                Provider.of<CartProvider>(context, listen: false).addToCart(cartItem);
                Navigator.pushNamed(context, '/cart'); // atau tampilkan snackbar
              },

              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text("Add to Cart"),
            ),
          ),
        ),
      ),
    );
  }
}
