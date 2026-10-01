import 'package:flutter/material.dart';
import '../../core/storage/user_storage.dart';
import 'auth_signin.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool emailChecked = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  Future<void> checkEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your email');
      return;
    }

    final savedEmail = await UserStorage.getEmail();

    if (!mounted) return;

    if (email == savedEmail) {
      setState(() {
        emailChecked = true;
      });

      showMessage('Email found');
    } else {
      showMessage('No account found with this email');
    }
  }

  Future<void> resetPassword() async {
    final password = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      showMessage('Please fill in all fields');
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

    await UserStorage.updatePassword(password);

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
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
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Forgot\npassword?',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Enter the email address connected to your account.',
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: emailController,
                enabled: !emailChecked,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  hint: 'Enter your email address',
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 22),
              if (!emailChecked)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: checkEmail,
                    style: buttonStyle(),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              AnimatedSize(
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.easeInOut,
                child: emailChecked
                    ? Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F4),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFFFF3B61),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Account found. Create a new password.',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller:
                                newPasswordController,
                            obscureText: hidePassword,
                            decoration: inputDecoration(
                              hint: 'New Password',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword =
                                        !hidePassword;
                                  });
                                },
                                icon: Icon(
                                  hidePassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller:
                                confirmPasswordController,
                            obscureText:
                                hideConfirmPassword,
                            decoration: inputDecoration(
                              hint: 'Confirm Password',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hideConfirmPassword =
                                        !hideConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  hideConfirmPassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : resetPassword,
                              style: buttonStyle(),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
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
      contentPadding: const EdgeInsets.symmetric(
        vertical: 17,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFD7D7D7),
        ),
      ),
      disabledBorder: OutlineInputBorder(
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

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF3B61),
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFFFF8197),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}