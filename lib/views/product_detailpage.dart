import 'package:flutter/material.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/views/cart_screen.dart';
import 'package:todo_app/views/orderConfirmationPage.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final bool fromCart;
  final int cartQuantity;

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.fromCart = false,
    this.cartQuantity = 1,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState
    extends State<ProductDetailPage> {
  bool isAddedToCart = false;
  bool isLoading = true;
  String errorMessage = '';

  Map<String, dynamic> product = {};

  @override
  void initState() {
    super.initState();
    loadSingleProduct();
  }

  Future<void> loadSingleProduct() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final data =
          await ApiService.getSingleProduct(
        widget.productId,
      );

      if (!mounted) return;

      setState(() {
        product = {
          ...data,
          'name': data['title'] ?? '',
          'image': data['thumbnail'] ?? '',
          'discount':
              '${data['discountPercentage'] ?? 0}%',
        };

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Failed to load product details.';
      });
    }
  }

  void _checkoutProduct() {
    final price =
        (product['price'] as num?)
                ?.toDouble() ??
            0;

    final total =
        price * widget.cartQuantity;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderConfirmationPage(
          totalAmount: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor =
        Color(0xFF512080);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 55,
                          color:
                              Colors.red.shade400,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        const Text(
                          'Failed to load product',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        const Text(
                          'Please check your internet connection and try again.',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        ElevatedButton(
                          onPressed:
                              loadSingleProduct,
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                primaryColor,
                            foregroundColor:
                                Colors.white,
                          ),
                          child:
                              const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(
                        maxWidth: 900,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Container(
                            width:
                                double.infinity,
                            height: MediaQuery.sizeOf(
                                                context)
                                            .width <
                                        600
                                    ? MediaQuery
                                                .sizeOf(
                                              context,
                                            )
                                                .width *
                                        0.70
                                    : 320,
                            decoration:
                                BoxDecoration(
                              color: primaryColor
                                  .withOpacity(
                                0.05,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                              child:
                                  Image.network(
                                product[
                                        'thumbnail'] ??
                                    '',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return const Icon(
                                    Icons
                                        .image_not_supported,
                                    size: 60,
                                    color:
                                        Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            product['title'] ??
                                'No Name',
                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 22,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(
                                '${product['rating'] ?? 0}',
                                style:
                                    const TextStyle(
                                  fontSize: 15,
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            '₹${product['price'] ?? 0}',
                            style:
                                const TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            product[
                                    'description'] ??
                                'Product description is not available.',
                            style:
                                const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          const Text(
                            'Product Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          infoRow(
                            'Category',
                            product[
                                    'category'] ??
                                'N/A',
                          ),

                          infoRow(
                            'Brand',
                            product['brand'] ??
                                'N/A',
                          ),

                          infoRow(
                            'Stock',
                            '${product['stock'] ?? 'N/A'}',
                          ),

                          infoRow(
                            'Discount',
                            '${product['discountPercentage'] ?? 0}%',
                          ),

                          infoRow(
                            'Warranty',
                            product[
                                    'warrantyInformation'] ??
                                'N/A',
                          ),

                          infoRow(
                            'Shipping',
                            product[
                                    'shippingInformation'] ??
                                'N/A',
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // =====================================================
                          // HOME-IL NINNU PRODUCT DETAIL OPEN CHEYYUMBOL
                          // ADD TO CART / GO TO CART KANIKKUM
                          // =====================================================

                          if (!widget.fromCart)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child:
                                  ElevatedButton(
                                onPressed:
                                    () async {
                                  if (!isAddedToCart) {
                                    try {
                                      await ApiService
                                          .addToCart(
                                        1,
                                        [
                                          {
                                            'id': product[
                                                'id'],
                                            'quantity':
                                                1,
                                          },
                                        ],
                                      );

                                      if (!mounted) {
                                        return;
                                      }

                                      setState(() {
                                        isAddedToCart =
                                            true;
                                      });

                                      ScaffoldMessenger
                                              .of(
                                        context,
                                      )
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(
                                            '${product['title']} added to cart',
                                          ),
                                          duration:
                                              const Duration(
                                            seconds:
                                                3,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger
                                              .of(
                                        context,
                                      )
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text(
                                            'Failed to add product to cart',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const CartPage(),
                                      ),
                                    );
                                  }
                                },
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      primaryColor,
                                  foregroundColor:
                                      Colors.white,
                                  elevation: 0,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  isAddedToCart
                                      ? 'GO TO CART'
                                      : 'ADD TO CART',
                                  style:
                                      const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),

                          // =====================================================
                          // CART-IL NINNU PRODUCT DETAIL OPEN CHEYYUMBOL
                          // ADD TO CART VENDA
                          // CHECKOUT MATHRAM
                          // =====================================================

                          if (widget.fromCart)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child:
                                  ElevatedButton(
                                onPressed:
                                    _checkoutProduct,
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      primaryColor,
                                  foregroundColor:
                                      Colors.white,
                                  elevation: 0,
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
                                  style:
                                      TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  static Widget infoRow(
    String title,
    dynamic value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const Text(': '),

          Expanded(
            child: Text(
              '$value',
              style:
                  const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}