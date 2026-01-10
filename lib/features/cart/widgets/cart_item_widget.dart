import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete; // Make sure this is defined

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete, // Make sure this is passed from the parent
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(cartItem.image,
            width: 50, height: 50), // Display product image
        title: Text(cartItem.name), // Display product name
        subtitle: Text('\$${cartItem.price}'), // Display product price
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove), // Decrease quantity button
              onPressed: onDecrease,
            ),
            Text('${cartItem.quantity}'), // Display quantity
            IconButton(
              icon: const Icon(Icons.add), // Increase quantity button
              onPressed: onIncrease,
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Colors.red), // Delete button
              onPressed: onDelete, // Correctly call onDelete function
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}
