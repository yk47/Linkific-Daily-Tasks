import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('₹${product.price}'),
        trailing: ElevatedButton(
          onPressed: () {
            context.read<CartProvider>().addToCart(product);
          },
          child: const Text('Add'),
        ),
      ),
    );
  }
}
