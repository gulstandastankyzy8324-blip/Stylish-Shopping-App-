import 'package:flutter/material.dart';
import '../../core/storage/user_storage.dart';
import '../home/home_page.dart';
import 'auth_forgotpassword.dart';
import 'auth_signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final savedEmail = await UserStorage.getEmail();
    final savedPassword = await UserStorage.getPassword();

    await Future.delayed(
      const Duration(milliseconds: 400),
    );

    if (!mounted) return;

    if (email == savedEmail && password == savedPassword) {
      await UserStorage.setLoggedIn(true);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        isLoading = false;
      });

      showMessage('Incorrect email or password');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Welcome\nBack!',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 45),
              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: inputDecoration(
                  hint: 'Username or Email',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: inputDecoration(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFFF3B61),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFF3B61),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFFFF8197),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 200),
                    child: isLoading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            key: ValueKey('login'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 45),
              const Center(
                child: Text(
                  '- OR Continue with -',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  socialButton('G'),
                  const SizedBox(width: 18),
                  socialButton('●'),
                  const SizedBox(width: 18),
                  socialButton('f'),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create An Account ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFFF3B61),
                        fontWeight: FontWeight.w600,
                        decoration:
                            TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: Colors.grey,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 17),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFD7D7D7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFFF3B61),
        ),
      ),
    );
  }

  Widget socialButton(String text) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFF3F5),
        border: Border.all(
          color: const Color(0xFFFF3B61),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}