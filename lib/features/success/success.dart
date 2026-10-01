import 'package:flutter/material.dart';
import '../../core/storage/cart_storage.dart';
import '../home/home_page.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() =>
      _SuccessScreenState();
}

class _SuccessScreenState
    extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    controller.forward();

    clearCart();
  }

  Future<void> clearCart() async {
    await CartStorage.clearCart();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5EA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFFFF3B61),
                    size: 78,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Payment done successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your order has been placed. Thank you for shopping with Stylish!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFF3B61),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}