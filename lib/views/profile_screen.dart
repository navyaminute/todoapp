import 'package:flutter/material.dart';
import 'package:todo_app/views/login_page.dart';
import 'package:todo_app/controllers/cart_manager.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor =
      const Color(0xFF512080);

  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final savedUsername =
        await ApiService.getUsername();

    if (mounted) {
      setState(() {
        username = savedUsername;
      });
    }
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
          'Profile',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width < 400 ? 12 : 16,
          vertical: 16,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    primaryColor.withOpacity(0.06),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        primaryColor,
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    username.isEmpty
                        ? 'User'
                        : username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // MY ACCOUNT
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Account',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // PERSONAL INFORMATION
            _profileItem(
              context,
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                _showDetails(
                  context,
                  'Personal Information',
                  'Username: $username',
                );
              },
            ),

            // MY ORDERS
            _profileItem(
              context,
              icon:
                  Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () async {
                await _showOrders(context);
              },
            ),

            const SizedBox(height: 25),

            // SETTINGS
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _profileItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                _showDetails(
                  context,
                  'Settings',
                  'App settings',
                );
              },
            ),

            const SizedBox(height: 25),

            // LOGOUT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor,
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor
              .withOpacity(0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primaryColor
                  .withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // SHOW ORDERS
  Future<void> _showOrders(
      BuildContext context) async {
    final orders =
        await CartManager.getOrders();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'My Orders',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: orders.isEmpty
                ? const Center(
                    child: Text(
                      'No orders placed yet.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder:
                        (context, index) {
                      final order =
                          orders[index];

                      final products =
                          List<dynamic>.from(
                        order['products'] ?? [],
                      );

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 15,
                        ),
                        padding:
                            const EdgeInsets.all(
                                12),
                        decoration:
                            BoxDecoration(
                          color: primaryColor
                              .withOpacity(0.05),
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Order #${order['orderId']}',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              'Status: ${order['status']}',
                              style:
                                  TextStyle(
                                color:
                                    primaryColor,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            const Text(
                              'Products:',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 5),

                            ...products.map(
                              (product) {
                                return Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    '${product['name']} × ${product['quantity']}',
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              'Total: ₹${(order['totalAmount'] as num).toStringAsFixed(0)}',
                              style:
                                  TextStyle(
                                color:
                                    primaryColor,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDetails(
    BuildContext context,
    String title,
    String details,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            details,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await ApiService.logout();

                if (context.mounted) {
                  Navigator.pop(context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryColor,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'LOGOUT',
              ),
            ),
          ],
        );
      },
    );
  }
}