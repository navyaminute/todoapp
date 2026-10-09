import 'package:flutter/material.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/views/orderConfirmationPage.dart';
import 'package:todo_app/views/product_detailpage.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic>? cartData;

  const CartPage({
    super.key,
    this.cartData,
  });

  @override
  State<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Color primaryColor =
      const Color(0xFF512080);

  List<Map<String, dynamic>> cartItems = [];

  int cartId = 1;

  @override
  void initState() {
    super.initState();

    ApiService.latestAddedCartNotifier
        .addListener(
      _latestCartChanged,
    );

    if (widget.cartData != null) {
      _loadPassedCart();
    } else {
      _loadCart();
    }
  }

  @override
  void dispose() {
    ApiService.latestAddedCartNotifier
        .removeListener(
      _latestCartChanged,
    );

    super.dispose();
  }

  void _latestCartChanged() {
    final latestCart =
        ApiService.latestAddedCartNotifier.value;

    if (latestCart == null) {
      return;
    }

    final List<dynamic> products =
        latestCart['products'] ?? [];

    final newCartId =
        (latestCart['id'] as num?)?.toInt() ?? 1;

    if (!mounted) return;

    setState(() {
      cartId = newCartId;

      cartItems =
          List<Map<String, dynamic>>.from(
        products.map(
          (product) =>
              Map<String, dynamic>.from(
            product,
          ),
        ),
      );
    });
  }

  void _loadPassedCart() {
    final data = widget.cartData!;

    final List<dynamic> products =
        data['products'] ?? [];

    cartId =
        (data['id'] as num?)?.toInt() ?? 1;

    if (!mounted) return;

    setState(() {
      cartItems =
          List<Map<String, dynamic>>.from(
        products.map(
          (product) =>
              Map<String, dynamic>.from(
            product,
          ),
        ),
      );
    });
  }

  Future<void> _loadCart() async {
    final latestCart =
        ApiService.latestAddedCart;

    if (latestCart != null) {
      final List<dynamic> products =
          latestCart['products'] ?? [];

      final latestCartId =
          (latestCart['id'] as num?)?.toInt() ??
              1;

      if (!mounted) return;

      setState(() {
        cartId = latestCartId;

        cartItems =
            List<Map<String, dynamic>>.from(
          products.map(
            (product) =>
                Map<String, dynamic>.from(
              product,
            ),
          ),
        );
      });

      return;
    }

    try {
      final data =
          await ApiService.getCartsByUser(5);

      final List<dynamic> carts =
          data['carts'] ?? [];

      if (carts.isEmpty) {
        if (!mounted) return;

        setState(() {
          cartItems = [];
        });

        return;
      }

      final firstCart =
          Map<String, dynamic>.from(
        carts.first,
      );

      final List<dynamic> products =
          firstCart['products'] ?? [];

      cartId =
          (firstCart['id'] as num?)?.toInt() ??
              1;

      if (!mounted) return;

      setState(() {
        cartItems =
            List<Map<String, dynamic>>.from(
          products.map(
            (product) =>
                Map<String, dynamic>.from(
              product,
            ),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cartItems = [];
      });
    }
  }

  Future<void> _increaseQuantity(
    int index,
  ) async {
    if (index < 0 ||
        index >= cartItems.length) {
      return;
    }

    final productId =
        (cartItems[index]['id'] as num?)
            ?.toInt();

    if (productId == null) {
      return;
    }

    final currentQuantity =
        (cartItems[index]['quantity'] as num?)
                ?.toInt() ??
            1;

    final newQuantity =
        currentQuantity + 1;

    try {
      await ApiService.updateCart(
        1,
        [
          {
            'id': productId,
            'quantity': newQuantity,
          },
        ],
        merge: true,
      );

      if (!mounted) return;

      setState(() {
        cartItems[index]['quantity'] =
            newQuantity;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Update failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> _decreaseQuantity(
    int index,
  ) async {
    if (index < 0 ||
        index >= cartItems.length) {
      return;
    }

    final productId =
        (cartItems[index]['id'] as num?)
            ?.toInt();

    if (productId == null) {
      return;
    }

    final currentQuantity =
        (cartItems[index]['quantity'] as num?)
                ?.toInt() ??
            1;

    if (currentQuantity <= 1) {
      return;
    }

    final newQuantity =
        currentQuantity - 1;

    try {
      await ApiService.updateCart(
        1,
        [
          {
            'id': productId,
            'quantity': newQuantity,
          },
        ],
        merge: true,
      );

      if (!mounted) return;

      setState(() {
        cartItems[index]['quantity'] =
            newQuantity;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Update failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> _removeProduct(
    int index,
  ) async {
    if (index < 0 ||
        index >= cartItems.length) {
      return;
    }

    try {
      final deletedCart =
          await ApiService.deleteCart(1);

      if (deletedCart['isDeleted'] == true) {
        if (!mounted) return;

        setState(() {
          cartItems.removeAt(index);
        });

        if (cartItems.isEmpty) {
          ApiService.clearLatestAddedCart();
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Product deleted successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete product: $e',
          ),
        ),
      );
    }
  }

  double _getTotal() {
    double total = 0;

    for (final item in cartItems) {
      final price =
          (item['price'] as num?)
                  ?.toDouble() ??
              0;

      final quantity =
          (item['quantity'] as num?)
                  ?.toInt() ??
              1;

      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.sizeOf(context)
                                .width <
                            400
                        ? 10
                        : 16,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            ListView.builder(
                          itemCount:
                              cartItems.length,
                          itemBuilder:
                              (context, index) {
                            final item =
                                cartItems[index];

                            final compact =
                                MediaQuery.sizeOf(
                                            context)
                                        .width <
                                    380;

                            final image =
                                item['thumbnail']
                                        ?.toString() ??
                                    item['image']
                                        ?.toString() ??
                                    '';

                            final title =
                                item['title']
                                        ?.toString() ??
                                    item['name']
                                        ?.toString() ??
                                    'Product';

                            final price =
                                (item['price']
                                            as num?)
                                        ?.toDouble() ??
                                    0;

                            final quantity =
                                (item['quantity']
                                            as num?)
                                        ?.toInt() ??
                                    1;

                            final productId =
                                (item['id'] as num?)
                                        ?.toInt() ??
                                    0;

                            return GestureDetector(
                              onTap: () {
                                if (productId == 0) {
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ProductDetailPage(
                                      productId:
                                          productId,
                                      fromCart: true,
                                      cartQuantity:
                                          quantity,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom: 15,
                                ),
                                padding:
                                    const EdgeInsets
                                        .all(10),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                  border:
                                      Border.all(
                                    color: primaryColor
                                        .withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10,
                                      ),
                                      child:
                                          Image.network(
                                        image,
                                        width:
                                            compact
                                                ? 64
                                                : 80,
                                        height:
                                            compact
                                                ? 64
                                                : 80,
                                        fit:
                                            BoxFit.cover,
                                        errorBuilder:
                                            (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width:
                                                compact
                                                    ? 64
                                                    : 80,
                                            height:
                                                compact
                                                    ? 64
                                                    : 80,
                                            color:
                                                primaryColor
                                                    .withOpacity(
                                              0.05,
                                            ),
                                            child:
                                                const Icon(
                                              Icons
                                                  .image_not_supported,
                                              color:
                                                  Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(
                                      width:
                                          compact
                                              ? 8
                                              : 15,
                                    ),

                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            title,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  16,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Text(
                                            '₹${price.toStringAsFixed(2)}',
                                            style:
                                                TextStyle(
                                              color:
                                                  primaryColor,
                                              fontSize:
                                                  15,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed:
                                                    () {
                                                  _decreaseQuantity(
                                                    index,
                                                  );
                                                },
                                                icon:
                                                    const Icon(
                                                  Icons
                                                      .remove,
                                                ),
                                              ),

                                              Text(
                                                '$quantity',
                                                style:
                                                    const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              IconButton(
                                                onPressed:
                                                    () {
                                                  _increaseQuantity(
                                                    index,
                                                  );
                                                },
                                                icon:
                                                    const Icon(
                                                  Icons
                                                      .add,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        _removeProduct(
                                          index,
                                        );
                                      },
                                      icon: Icon(
                                        Icons
                                            .delete_outline,
                                        color:
                                            primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .all(16),
                        decoration:
                            BoxDecoration(
                          color: primaryColor
                              .withOpacity(
                            0.06,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            Text(
                              '₹${_getTotal().toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    primaryColor,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 50,
                        child:
                            ElevatedButton(
                          onPressed:
                              cartItems.isEmpty
                                  ? null
                                  : () {
                                      final total =
                                          _getTotal();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  OrderConfirmationPage(
                                            totalAmount:
                                                total,
                                          ),
                                        ),
                                      );
                                    },
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                primaryColor,
                            foregroundColor:
                                Colors.white,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),
                          ),
                          child:
                              const Text(
                            'CHECKOUT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}