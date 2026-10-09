import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static final List<Map<String, dynamic>> cartItems = [];

  // LOAD SAVED CART
  static Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCart = prefs.getString('cartItems');

    if (savedCart != null && savedCart.isNotEmpty) {
      final List<dynamic> decodedCart = jsonDecode(savedCart);

      cartItems.clear();

      for (final item in decodedCart) {
        cartItems.add(
          Map<String, dynamic>.from(item),
        );
      }
    }
  }

  // SAVE CART
  static Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'cartItems',
      jsonEncode(cartItems),
    );
  }

  // ADD PRODUCT TO CART
  static Future<void> addToCart(
    Map<String, dynamic> product,
  ) async {
    await loadCart();

    final existingIndex = cartItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity'] =
          (cartItems[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      cartItems.add({
        ...product,
        'quantity': 1,
      });
    }

    await saveCart();
  }

  // ADD PRODUCT
  static Future<void> addProduct(
    Map<String, dynamic> product,
  ) async {
    await addToCart(product);
  }

  // REMOVE PRODUCT
  static Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);

      await saveCart();
    }
  }

  // INCREASE QUANTITY
  static Future<void> increaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index]['quantity'] =
          (cartItems[index]['quantity'] ?? 1) + 1;

      await saveCart();
    }
  }

  // DECREASE QUANTITY
  static Future<void> decreaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final quantity =
          cartItems[index]['quantity'] ?? 1;

      if (quantity > 1) {
        cartItems[index]['quantity'] = quantity - 1;

        await saveCart();
      }
    }
  }

  // CLEAR CART
  static Future<void> clearCart() async {
    cartItems.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('cartItems');
  }

  // TOTAL
  static double getTotal() {
    double total = 0;

    for (final item in cartItems) {
      final priceString = item['price']
          .toString()
          .replaceAll('₹', '')
          .replaceAll(',', '');

      final price =
          double.tryParse(priceString) ?? 0;

      final quantity =
          (item['quantity'] as num?)?.toInt() ?? 1;

      total += price * quantity;
    }

    return total;
  }

  // SAVE ORDER
  static Future<void> saveOrder(
    List<Map<String, dynamic>> products,
    double totalAmount,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final savedOrders = prefs.getString('orders');

    List<dynamic> orders = [];

    if (savedOrders != null && savedOrders.isNotEmpty) {
      orders = jsonDecode(savedOrders);
    }

    final order = {
      'orderId':
          DateTime.now().millisecondsSinceEpoch.toString(),
      'date':
          DateTime.now().toIso8601String(),
      'totalAmount': totalAmount,
      'status': 'Placed',
      'products': products,
    };

    orders.add(order);

    await prefs.setString(
      'orders',
      jsonEncode(orders),
    );
  }

  // GET ORDERS
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final savedOrders = prefs.getString('orders');

    if (savedOrders == null || savedOrders.isEmpty) {
      return [];
    }

    final List<dynamic> decodedOrders =
        jsonDecode(savedOrders);

    return decodedOrders
        .map(
          (order) =>
              Map<String, dynamic>.from(order),
        )
        .toList()
        .reversed
        .toList();
  }
}  