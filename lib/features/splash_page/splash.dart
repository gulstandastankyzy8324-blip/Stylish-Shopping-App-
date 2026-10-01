import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/storage/user_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    controller.forward();
    openNextPage();
  }

  Future<void> openNextPage() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final onboardingSeen =
        await UserStorage.isOnboardingSeen();

    final loggedIn =
        await UserStorage.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
      return;
    }

    if (onboardingSeen) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.signIn,
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.onboarding,
    );
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
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFFFF3B61),
                size: 55,
              ),
              SizedBox(width: 10),
              Text(
                'Stylish',
                style: TextStyle(
                  color: Color(0xFFFF3B61),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}