import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  // =========================================================
  // LATEST CART
  // =========================================================

  static Map<String, dynamic>? latestAddedCart;

  static final ValueNotifier<Map<String, dynamic>?>
      latestAddedCartNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  static void setLatestAddedCart(
    Map<String, dynamic> cart,
  ) {
    latestAddedCart =
        Map<String, dynamic>.from(cart);

    latestAddedCartNotifier.value =
        Map<String, dynamic>.from(cart);
  }

  static void clearLatestAddedCart() {
    latestAddedCart = null;
    latestAddedCartNotifier.value = null;
  }

  // =========================================================
  // LOGIN API
  // =========================================================

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs =
            await SharedPreferences.getInstance();

        await prefs.setBool(
          'isLoggedIn',
          true,
        );

        await prefs.setString(
          'username',
          data['username'] ?? username,
        );

        await prefs.setString(
          'email',
          data['email'] ?? '',
        );

        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message':
              data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message':
            'Something went wrong. Please check your internet connection.',
      };
    }
  }

  // =========================================================
  // GET ALL PRODUCTS
  // =========================================================

  static Future<Map<String, dynamic>>
      getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load products',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading products: $e',
      );
    }
  }

  // =========================================================
  // GET SINGLE PRODUCT
  // =========================================================

  static Future<Map<String, dynamic>>
      getSingleProduct(
    int id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load product',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading product: $e',
      );
    }
  }

  // =========================================================
  // SEARCH PRODUCTS
  // =========================================================

  static Future<Map<String, dynamic>>
      searchProducts(
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/products/search?q=${Uri.encodeComponent(query)}',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to search products',
        );
      }
    } catch (e) {
      throw Exception(
        'Error searching products: $e',
      );
    }
  }

  // =========================================================
  // SORT PRODUCTS
  // =========================================================

  static Future<Map<String, dynamic>>
      sortProducts(
    String order,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/products?sortBy=title&order=$order',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to sort products',
        );
      }
    } catch (e) {
      throw Exception(
        'Error sorting products: $e',
      );
    }
  }

  // =========================================================
  // GET ALL PRODUCT CATEGORIES
  // =========================================================

  static Future<List<Map<String, dynamic>>>
      getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/products/categories',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          data,
        );
      } else {
        throw Exception(
          'Failed to load categories',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading categories: $e',
      );
    }
  }

  // =========================================================
  // GET PRODUCTS BY CATEGORY
  // =========================================================

  static Future<Map<String, dynamic>>
      getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/products/category/$category',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load category products',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading category products: $e',
      );
    }
  }

  // =========================================================
  // GET ALL CARTS
  // GET https://dummyjson.com/carts
  // =========================================================

  static Future<Map<String, dynamic>>
      getAllCarts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load carts',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading carts: $e',
      );
    }
  }

  // =========================================================
  // GET SINGLE CART
  // GET https://dummyjson.com/carts/1
  // =========================================================

  static Future<Map<String, dynamic>>
      getSingleCart(
    int id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts/$id'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load cart',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading cart: $e',
      );
    }
  }

  // =========================================================
  // GET CARTS BY USER
  // GET https://dummyjson.com/carts/user/5
  // =========================================================

  static Future<Map<String, dynamic>>
      getCartsByUser(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/carts/user/$userId',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load user carts',
        );
      }
    } catch (e) {
      throw Exception(
        'Error loading user carts: $e',
      );
    }
  }

  // =========================================================
  // ADD TO CART
  // POST https://dummyjson.com/carts/add
  // =========================================================

  static Future<Map<String, dynamic>>
      addToCart(
    int userId,
    List<Map<String, dynamic>> products,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/carts/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': products,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        // ==================================================
        // FIRST PRODUCT
        // ==================================================

        if (latestAddedCart == null) {
          setLatestAddedCart(data);
          return latestAddedCart!;
        }

        // ==================================================
        // OLD PRODUCTS
        // ==================================================

        final List<Map<String, dynamic>>
            oldProducts =
            List<Map<String, dynamic>>.from(
          (latestAddedCart!['products'] ?? [])
              .map(
            (item) =>
                Map<String, dynamic>.from(item),
          ),
        );

        // ==================================================
        // NEW PRODUCTS
        // ==================================================

        final List<Map<String, dynamic>>
            newProducts =
            List<Map<String, dynamic>>.from(
          (data['products'] ?? [])
              .map(
            (item) =>
                Map<String, dynamic>.from(item),
          ),
        );

        // ==================================================
        // MERGE OLD + NEW
        // ==================================================

        for (final newProduct in newProducts) {
          final newProductId =
              newProduct['id'];

          final existingIndex =
              oldProducts.indexWhere(
            (oldProduct) =>
                oldProduct['id'] ==
                newProductId,
          );

          if (existingIndex != -1) {
            final oldQuantity =
                (oldProducts[existingIndex]
                            ['quantity']
                        as num?)
                    ?.toInt() ??
                1;

            final newQuantity =
                (newProduct['quantity']
                        as num?)
                    ?.toInt() ??
                1;

            oldProducts[existingIndex]
                    ['quantity'] =
                oldQuantity + newQuantity;
          } else {
            oldProducts.add(
              Map<String, dynamic>.from(
                newProduct,
              ),
            );
          }
        }

        final Map<String, dynamic>
            combinedCart =
            Map<String, dynamic>.from(
          latestAddedCart!,
        );

        combinedCart['products'] =
            oldProducts;

        combinedCart['userId'] =
            data['userId'] ??
                combinedCart['userId'] ??
                userId;

        combinedCart['id'] =
            latestAddedCart!['id'] ??
                data['id'];

        setLatestAddedCart(
          combinedCart,
        );

        return latestAddedCart!;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to add cart',
        );
      }
    } catch (e) {
      throw Exception(
        'Error adding cart: $e',
      );
    }
  }

  // =========================================================
  // UPDATE CART
  // PUT https://dummyjson.com/carts/{id}
  // =========================================================

  static Future<Map<String, dynamic>>
      updateCart(
    int cartId,
    List<Map<String, dynamic>> products, {
    bool merge = true,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseUrl/carts/$cartId',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'merge': merge,
          'products': products,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          data['message'] ??
              'Failed to update cart',
        );
      }

      // ======================================================
      // UPDATE LOCAL CART STATE
      // ======================================================

      if (latestAddedCart != null) {
        final updatedCart =
            Map<String, dynamic>.from(
          latestAddedCart!,
        );

        final List<Map<String, dynamic>>
            oldProducts =
            List<Map<String, dynamic>>.from(
          (updatedCart['products'] ?? [])
              .map(
            (item) =>
                Map<String, dynamic>.from(
              item,
            ),
          ),
        );

        // ====================================================
        // UPDATE REQUESTED PRODUCT QUANTITY
        // ====================================================

        for (final updatedProduct in products) {
          final productId =
              updatedProduct['id'];

          final newQuantity =
              (updatedProduct['quantity']
                          as num?)
                      ?.toInt() ??
                  1;

          final productIndex =
              oldProducts.indexWhere(
            (item) =>
                item['id'] == productId,
          );

          if (productIndex != -1) {
            oldProducts[productIndex]
                    ['quantity'] =
                newQuantity;
          }
        }

        // ====================================================
        // UPDATE LOCAL CART
        // ====================================================

        updatedCart['products'] =
            oldProducts;

        // ====================================================
        // UPDATE TOTALS
        // ====================================================

        int totalProducts =
            oldProducts.length;

        int totalQuantity = 0;

        double total = 0;

        for (final item in oldProducts) {
          final quantity =
              (item['quantity'] as num?)
                      ?.toInt() ??
                  1;

          final price =
              (item['price'] as num?)
                      ?.toDouble() ??
                  0;

          totalQuantity += quantity;

          total += price * quantity;
        }

        updatedCart['totalProducts'] =
            totalProducts;

        updatedCart['totalQuantity'] =
            totalQuantity;

        updatedCart['total'] =
            total;

        // Keep original local cart ID.
        updatedCart['id'] =
            latestAddedCart!['id'];

        setLatestAddedCart(
          updatedCart,
        );
      }

      return data;
    } catch (e) {
      throw Exception(
        'Error updating cart: $e',
      );
    }
  }

  // =========================================================
  // DELETE CART
  // DELETE https://dummyjson.com/carts/{id}
  // =========================================================

  static Future<Map<String, dynamic>>
      deleteCart(
    int cartId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/carts/$cartId',
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ??
              'Failed to delete cart',
        );
      }
    } catch (e) {
      throw Exception(
        'Error deleting cart: $e',
      );
    }
  }

  // =========================================================
  // GET USERNAME
  // =========================================================

  static Future<String> getUsername() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('username') ?? '';
  }

  // =========================================================
  // GET EMAIL
  // =========================================================

  static Future<String> getEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('email') ?? '';
  }

  // =========================================================
  // CHECK LOGIN
  // =========================================================

  static Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  static Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'isLoggedIn',
      false,
    );

    await prefs.remove('username');

    await prefs.remove('email');

    clearLatestAddedCart();
  }
}