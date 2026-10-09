import 'package:flutter/material.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/views/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final Color primaryColor = const Color(0xFF512080);

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // LOGIN
  // =========================

  Future<void> loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showMessage(
        'Please enter username and password',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        username,
        password,
      );

      if (result['success'] == true) {
        final data = result['data'];

        debugPrint('Login successful');
        debugPrint('User ID: ${data['id']}');
        debugPrint('Username: ${data['username']}');

        if (!mounted) return;

        // GO TO HOME
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        showMessage(
          result['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      debugPrint('Login Error: $e');

      showMessage(
        'Something went wrong',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // MESSAGE
  // =========================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // =========================
  // INPUT DECORATION
  // =========================

  InputDecoration fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: primaryColor,
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 45),

                    // ICON
                    Icon(
                      Icons.auto_awesome,
                      size: 55,
                      color: primaryColor,
                    ),

                    const SizedBox(height: 25),

                    // TITLE
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      ' Login to continue shopping',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 55),

                    // USERNAME
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: fieldDecoration(
                        hint: 'Enter your username',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // PASSWORD
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: fieldDecoration(
                        hint: 'Enter password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}