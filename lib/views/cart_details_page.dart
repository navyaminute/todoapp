// import 'package:flutter/material.dart';
// import 'package:todo_app/services/api_service.dart';

// class CartDetailsPage extends StatefulWidget {
//   final int cartId;

//   const CartDetailsPage({
//     super.key,
//     required this.cartId,
//   });

//   @override
//   State<CartDetailsPage> createState() =>
//       _CartDetailsPageState();
// }

// class _CartDetailsPageState
//     extends State<CartDetailsPage> {
//   final Color primaryColor =
//       const Color(0xFF512080);

//   Map<String, dynamic>? cart;

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadCartDetails();
//   }

//   Future<void> _loadCartDetails() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final data =
//           await ApiService.getSingleCart(
//         widget.cartId,
//       );

//       if (!mounted) return;

//       setState(() {
//         cart = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isLoading = false;
//       });

//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         SnackBar(
//           content: Text(
//             e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: primaryColor,
//           ),
//         ),
//         title: Text(
//           'Cart Details',
//           style: TextStyle(
//             color: primaryColor,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       body: isLoading
//           ? Center(
//               child:
//                   CircularProgressIndicator(
//                 color: primaryColor,
//               ),
//             )
//           : cart == null
//               ? const Center(
//                   child: Text(
//                     'Cart details not found',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 )
//               : _buildCartDetails(),
//     );
//   }

//   Widget _buildCartDetails() {
//     final cartData = cart!;

//     final cartId =
//         (cartData['id'] as num?)?.toInt() ??
//             0;

//     final userId =
//         (cartData['userId'] as num?)?.toInt() ??
//             0;

//     final total =
//         (cartData['total'] as num?)
//                 ?.toDouble() ??
//             0;

//     final discountedTotal =
//         (cartData['discountedTotal'] as num?)
//                 ?.toDouble() ??
//             0;

//     final totalProducts =
//         (cartData['totalProducts'] as num?)
//                 ?.toInt() ??
//             0;

//     final totalQuantity =
//         (cartData['totalQuantity'] as num?)
//                 ?.toInt() ??
//             0;

//     final products =
//         cartData['products'] ?? [];

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal:
//             MediaQuery.sizeOf(context).width <
//                     400
//                 ? 10
//                 : 16,
//         vertical: 16,
//       ),
//       child: Center(
//         child: ConstrainedBox(
//           constraints:
//               const BoxConstraints(
//             maxWidth: 900,
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: primaryColor
//                       .withOpacity(0.06),
//                   borderRadius:
//                       BorderRadius.circular(
//                     15,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Cart #$cartId',
//                       style:
//                           const TextStyle(
//                         fontSize: 20,
//                         fontWeight:
//                             FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(
//                       height: 12,
//                     ),

//                     Text(
//                       'User ID: $userId',
//                       style:
//                           const TextStyle(
//                         fontSize: 15,
//                         color: Colors.grey,
//                       ),
//                     ),

//                     const SizedBox(
//                       height: 15,
//                     ),

//                     Row(
//                       children: [
//                         Expanded(
//                           child:
//                               _summaryItem(
//                             'Products',
//                             '$totalProducts',
//                           ),
//                         ),
//                         Expanded(
//                           child:
//                               _summaryItem(
//                             'Quantity',
//                             '$totalQuantity',
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(
//                       height: 15,
//                     ),

//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment
//                               .spaceBetween,
//                       children: [
//                         const Text(
//                           'Total',
//                           style:
//                               TextStyle(
//                             fontSize: 16,
//                             fontWeight:
//                                 FontWeight
//                                     .bold,
//                           ),
//                         ),
//                         Text(
//                           '₹${total.toStringAsFixed(2)}',
//                           style:
//                               TextStyle(
//                             color:
//                                 primaryColor,
//                             fontSize: 18,
//                             fontWeight:
//                                 FontWeight
//                                     .bold,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(
//                       height: 8,
//                     ),

//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment
//                               .spaceBetween,
//                       children: [
//                         const Text(
//                           'Discounted Total',
//                           style:
//                               TextStyle(
//                             fontSize: 16,
//                             fontWeight:
//                                 FontWeight
//                                     .bold,
//                           ),
//                         ),
//                         Text(
//                           '₹${discountedTotal.toStringAsFixed(2)}',
//                           style:
//                               const TextStyle(
//                             color:
//                                 Colors.green,
//                             fontSize: 18,
//                             fontWeight:
//                                 FontWeight
//                                     .bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(
//                 height: 20,
//               ),

//               const Align(
//                 alignment:
//                     Alignment.centerLeft,
//                 child: Text(
//                   'Products',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight:
//                         FontWeight.bold,
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 12,
//               ),

//               Expanded(
//                 child: products.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No products in this cart',
//                           style:
//                               TextStyle(
//                             color:
//                                 Colors.grey,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount:
//                             products.length,
//                         itemBuilder:
//                             (context, index) {
//                           final product =
//                               Map<String,
//                                   dynamic>.from(
//                             products[index],
//                           );

//                           final image =
//                               product[
//                                           'thumbnail']
//                                       ?.toString() ??
//                                   '';

//                           final title =
//                               product['title']
//                                       ?.toString() ??
//                                   'Product';

//                           final price =
//                               (product[
//                                           'price']
//                                       as num?)
//                                   ?.toDouble() ??
//                               0;

//                           final quantity =
//                               (product[
//                                           'quantity']
//                                       as num?)
//                                   ?.toInt() ??
//                               1;

//                           final productTotal =
//                               (product[
//                                           'total']
//                                       as num?)
//                                   ?.toDouble() ??
//                               0;

//                           final discountedProductTotal =
//                               (product[
//                                           'discountedTotal']
//                                       as num?)
//                                   ?.toDouble() ??
//                               0;

//                           return Container(
//                             margin:
//                                 const EdgeInsets
//                                     .only(
//                               bottom: 15,
//                             ),
//                             padding:
//                                 const EdgeInsets
//                                     .all(10),
//                             decoration:
//                                 BoxDecoration(
//                               color:
//                                   Colors.white,
//                               borderRadius:
//                                   BorderRadius
//                                       .circular(
//                                 12,
//                               ),
//                               border:
//                                   Border.all(
//                                 color:
//                                     primaryColor
//                                         .withOpacity(
//                                   0.2,
//                                 ),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                     10,
//                                   ),
//                                   child:
//                                       Image.network(
//                                     image,
//                                     width: 80,
//                                     height: 80,
//                                     fit: BoxFit
//                                         .cover,
//                                     errorBuilder:
//                                         (
//                                       context,
//                                       error,
//                                       stackTrace,
//                                     ) {
//                                       return Container(
//                                         width: 80,
//                                         height: 80,
//                                         color:
//                                             primaryColor
//                                                 .withOpacity(
//                                           0.05,
//                                         ),
//                                         child:
//                                             const Icon(
//                                           Icons
//                                               .image_not_supported,
//                                           color:
//                                               Colors.grey,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),

//                                 const SizedBox(
//                                   width: 15,
//                                 ),

//                                 Expanded(
//                                   child:
//                                       Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                     children: [
//                                       Text(
//                                         title,
//                                         maxLines:
//                                             2,
//                                         overflow:
//                                             TextOverflow
//                                                 .ellipsis,
//                                         style:
//                                             const TextStyle(
//                                           fontSize:
//                                               16,
//                                           fontWeight:
//                                               FontWeight
//                                                   .bold,
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 6,
//                                       ),

//                                       Text(
//                                         'Price: ₹${price.toStringAsFixed(2)}',
//                                         style:
//                                             TextStyle(
//                                           color:
//                                               primaryColor,
//                                           fontSize:
//                                               14,
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 4,
//                                       ),

//                                       Text(
//                                         'Quantity: $quantity',
//                                         style:
//                                             const TextStyle(
//                                           fontSize:
//                                               14,
//                                           color:
//                                               Colors.grey,
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 4,
//                                       ),

//                                       Text(
//                                         'Total: ₹${productTotal.toStringAsFixed(2)}',
//                                         style:
//                                             const TextStyle(
//                                           fontSize:
//                                               14,
//                                           fontWeight:
//                                               FontWeight
//                                                   .bold,
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 4,
//                                       ),

//                                       Text(
//                                         'After Discount: ₹${discountedProductTotal.toStringAsFixed(2)}',
//                                         style:
//                                             const TextStyle(
//                                           fontSize:
//                                               14,
//                                           color:
//                                               Colors.green,
//                                           fontWeight:
//                                               FontWeight
//                                                   .bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _summaryItem(
//     String title,
//     String value,
//   ) {
//     return Column(
//       crossAxisAlignment:
//           CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style:
//               const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(
//           height: 4,
//         ),
//         Text(
//           value,
//           style:
//               const TextStyle(
//             fontSize: 17,
//             fontWeight:
//                 FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }