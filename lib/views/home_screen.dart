import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/views/cart_screen.dart';
import 'package:todo_app/views/product_detailpage.dart';
import 'package:todo_app/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF512080);

  int selectedIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';

  String? selectedCategory;

  String sortOrder = 'asc';

  List<dynamic> products = [];
  List<Map<String, dynamic>> categories = [];

  bool isLoading = true;
  bool isCategoryLoading = false;

  Timer? searchTimer;

  @override
  void initState() {
    super.initState();

    loadProducts();
    loadCategories();
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // GET ALL PRODUCTS
  // =========================================================

  Future<void> loadProducts() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.getAllProducts();

      if (!mounted) return;

      setState(() {
        products = data['products'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  // =========================================================
  // GET CATEGORIES
  // =========================================================

  Future<void> loadCategories() async {
    try {
      final data = await ApiService.getCategories();

      if (!mounted) return;

      setState(() {
        categories = data;
      });
    } catch (e) {
      debugPrint('Category error: $e');
    }
  }

  // =========================================================
  // SEARCH PRODUCTS
  // =========================================================

  void onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });

    searchTimer?.cancel();

    if (value.trim().isEmpty) {
      loadProducts();
      return;
    }

    searchTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        searchProducts(value.trim());
      },
    );
  }

  Future<void> searchProducts(String query) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.searchProducts(query);

      if (!mounted) return;

      setState(() {
        products = data['products'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  // =========================================================
  // SORT PRODUCTS
  // =========================================================

  Future<void> sortProducts(String order) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      sortOrder = order;
    });

    try {
      final data = await ApiService.sortProducts(order);

      if (!mounted) return;

      setState(() {
        products = data['products'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  // =========================================================
  // CATEGORY PRODUCTS
  // =========================================================

  Future<void> loadProductsByCategory(String category) async {
    if (!mounted) return;

    setState(() {
      isCategoryLoading = true;
      isLoading = true;
      selectedCategory = category;
    });

    try {
      final data =
          await ApiService.getProductsByCategory(category);

      if (!mounted) return;

      setState(() {
        products = data['products'] ?? [];
        isLoading = false;
        isCategoryLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isCategoryLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  // =========================================================
  // ALL CATEGORIES
  // =========================================================

  Future<void> selectAllCategories() async {
    setState(() {
      selectedCategory = null;
    });

    await loadProducts();
  }

  // =========================================================
  // CATEGORY BUTTON
  // =========================================================

  Widget categoryButton() {
    String buttonText = 'All Categories';

    if (selectedCategory != null) {
      final selected = categories.firstWhere(
        (category) =>
            category['slug'] == selectedCategory,
        orElse: () => {},
      );

      buttonText =
          selected['name']?.toString() ??
          selectedCategory!;
    }

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'all') {
          selectAllCategories();
        } else {
          loadProductsByCategory(value);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: 'all',
            child: Text('All Categories'),
          ),
          ...categories.map(
            (category) {
              return PopupMenuItem<String>(
                value: category['slug'].toString(),
                child: Text(
                  category['name'].toString(),
                ),
              );
            },
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SORT BUTTON
  // =========================================================

  Widget sortButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        sortProducts(value);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) {
        return const [
          PopupMenuItem<String>(
            value: 'asc',
            child: Text('A → Z'),
          ),
          PopupMenuItem<String>(
            value: 'desc',
            child: Text('Z → A'),
          ),
        ];
      },
      icon: Icon(
        Icons.sort,
        color: primaryColor,
      ),
    );
  }

  // =========================================================
  // PRODUCT CARD
  // =========================================================

  Widget productCard(Map<String, dynamic> product) {
    final image =
        product['thumbnail']?.toString() ?? '';

    final title =
        product['title']?.toString() ?? 'Product';

    final price =
        product['price'] ?? 0;

    return GestureDetector(
      onTap: () {
        final id = product['id'];

        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(
                productId: id,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color:
                          primaryColor.withOpacity(0.05),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding:
                    const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹$price',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HOME CONTENT
  // =========================================================

  Widget homeContent() {
    return RefreshIndicator(
      onRefresh: loadProducts,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.sizeOf(context).width < 400
                  ? 10
                  : 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                categoryButton(),
                sortButton(),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchText.isNotEmpty
                      ? 'Search Results'
                      : 'Products',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${products.length} items',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : products.isEmpty
                      ? const Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.sizeOf(context)
                                            .width <
                                        600
                                    ? 2
                                    : 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                MediaQuery.sizeOf(context)
                                            .width <
                                        400
                                    ? 0.70
                                    : 0.75,
                          ),
                          itemBuilder:
                              (context, index) {
                            final product =
                                Map<String, dynamic>.from(
                              products[index],
                            );

                            return productCard(
                              product,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final pages = [
      homeContent(),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // IMPORTANT:
      // Welcome + Search ONLY on Home screen
      appBar: selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Welcome to ShopEase',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: PreferredSize(
                preferredSize:
                    const Size.fromHeight(65),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    10,
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText:
                          'Search products',
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      suffixIcon:
                          searchText.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    searchController
                                        .clear();

                                    setState(() {
                                      searchText =
                                          '';
                                    });

                                    searchTimer
                                        ?.cancel();

                                    loadProducts();
                                  },
                                  icon:
                                      const Icon(
                                    Icons.clear,
                                    color:
                                        Colors.grey,
                                  ),
                                )
                              : null,
                      contentPadding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 12,
                      ),
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}