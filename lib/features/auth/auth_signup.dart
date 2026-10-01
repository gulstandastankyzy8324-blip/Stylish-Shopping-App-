import 'package:flutter/material.dart';
import '../../core/storage/user_storage.dart';
import '../home/home_page.dart';
import 'auth_signin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  Future<void> createAccount() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    if (!email.contains('@')) {
      showMessage('Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await UserStorage.saveUser(
      name: username,
      email: email,
      password: password,
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              const SizedBox(height: 35),
              const Text(
                'Create an\naccount',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 38),
              buildField(
                controller: usernameController,
                hint: 'Username',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              buildField(
                controller: emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              buildField(
                controller: passwordController,
                hint: 'Password',
                icon: Icons.lock_outline,
                obscureText: hidePassword,
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
              const SizedBox(height: 16),
              buildField(
                controller: confirmPasswordController,
                hint: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: hideConfirmPassword,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      hideConfirmPassword =
                          !hideConfirmPassword;
                    });
                  },
                  icon: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'By clicking the Register button, you agree to the public offer',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : createAccount,
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
                            'Create Account',
                            key: ValueKey('text'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '- OR Continue with -',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'I Already Have an Account ',
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
                              const SignInScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
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