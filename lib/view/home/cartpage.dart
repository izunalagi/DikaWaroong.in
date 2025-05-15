import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      leading: Image.asset(item.image, width: 50, height: 50),
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text('Rp ${item.price * item.quantity}'),
                    );
                  },
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'Total:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      'Rp ${cart.totalPrice.toInt()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/qris');
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
