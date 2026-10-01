import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_forgotpassword.dart';
import 'features/auth/auth_signin.dart';
import 'features/auth/auth_signup.dart';
import 'features/checkout/checkout_screen.dart';
import 'features/checkout/placeorder.dart';
import 'features/checkout/shipping.dart';
import 'features/home/home_page.dart';
import 'features/onboarding /onboarding_screen.dart';
import 'features/profile/profile.dart';
import 'features/shop/shop_screen.dart';
import 'features/splash_page/splash.dart';
import 'features/success/success.dart';

void main() {
  runApp(const StylishApp());
}

class StylishApp extends StatelessWidget {
  const StylishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stylish',
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.onboarding: (context) =>
            const OnboardingScreen(),
        AppRoutes.signIn: (context) =>
            const SignInScreen(),
        AppRoutes.signUp: (context) =>
            const SignUpScreen(),
        AppRoutes.forgotPassword: (context) =>
            const ForgotPasswordScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.shop: (context) => const ShopScreen(),
        AppRoutes.profile: (context) =>
            const ProfileScreen(),
        AppRoutes.checkout: (context) =>
            const CheckoutScreen(),
        AppRoutes.placeOrder: (context) =>
            const PlaceOrderScreen(),
        AppRoutes.shipping: (context) =>
            const ShippingScreen(),
        AppRoutes.success: (context) =>
            const SuccessScreen(),
      },
    );
  }
}