class CartItem {
  final String name;
  final double price;
  final String image;
  final int quantity; // Changed to final

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  // Helper method for state management
  CartItem copyWith({int? quantity}) {
    return CartItem(
      name: name,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }
}
