import 'package:flutter/material.dart';
import 'package:project/models/cartitem.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem item) {
    final index = _items.indexWhere((e) => e.idProduk == item.idProduk);
    if (index != -1) {
      // Pastikan quantity tidak null
      _items[index].quantity =
          (_items[index].quantity ?? 1) + (item.quantity ?? 1);
    } else {
      // Jika quantity null, ubah jadi 1 sebelum ditambahkan
      _items.add(
        CartItem(
          idProduk: item.idProduk,
          name: item.name,
          price: item.price ?? 0,
          image: item.image,
          quantity: item.quantity ?? 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + (item.quantity ?? 0));

  double get totalPrice => _items.fold(
    0,
    (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 0)),
  );

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
