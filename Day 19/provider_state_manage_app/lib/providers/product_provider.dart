import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop',
      price: 50000,
      emoji: '💻',
      category: 'Computing',
    ),
    Product(
      id: '2',
      name: 'Mouse',
      price: 500,
      emoji: '🖱️',
      category: 'Accessories',
    ),
    Product(
      id: '3',
      name: 'Keyboard',
      price: 1500,
      emoji: '⌨️',
      category: 'Accessories',
    ),
    Product(
      id: '4',
      name: 'Monitor',
      price: 12000,
      emoji: '🖥️',
      category: 'Displays',
    ),
    Product(
      id: '5',
      name: 'Headphones',
      price: 3500,
      emoji: '🎧',
      category: 'Audio',
    ),
    Product(
      id: '6',
      name: 'Webcam',
      price: 2800,
      emoji: '📷',
      category: 'Accessories',
    ),
  ];

  List<Product> get products => _products;
}
