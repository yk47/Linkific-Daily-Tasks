import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _quantities = {};
  final Map<String, Product> _cartMap = {};

  List<Product> get cartItems => _cartMap.values.toList();
  Map<String, int> get quantities => _quantities;

  int quantityOf(String id) => _quantities[id] ?? 0;
  bool isInCart(String id) => _cartMap.containsKey(id);

  int get totalItems => _quantities.values.fold(0, (a, b) => a + b);

  double get totalPrice => _cartMap.values.fold(
    0,
    (sum, item) => sum + item.price * (_quantities[item.id] ?? 1),
  );

  void addToCart(Product product) {
    _cartMap[product.id] = product;
    _quantities[product.id] = (_quantities[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeOneFromCart(Product product) {
    final qty = _quantities[product.id] ?? 0;
    if (qty <= 1) {
      _cartMap.remove(product.id);
      _quantities.remove(product.id);
    } else {
      _quantities[product.id] = qty - 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartMap.remove(product.id);
    _quantities.remove(product.id);
    notifyListeners();
  }

  void clearCart() {
    _cartMap.clear();
    _quantities.clear();
    notifyListeners();
  }
}
