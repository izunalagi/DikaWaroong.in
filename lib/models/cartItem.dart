class CartItem {
  final int idProduk;
  final String name;
  final String image;
  final int price;
  int quantity;

  CartItem({
    required this.idProduk,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}
