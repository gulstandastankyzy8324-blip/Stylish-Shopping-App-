import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import 'data/onboarding_data.dart';
import 'models/onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  bool get _isLastPage =>
      _currentPage == onboardingPages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.signUp,
    );
  }

  void _nextPage() {
    if (_isLastPage) {
      _goToSignUp();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _previousPage() {
    if (_currentPage == 0) {
      return;
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _Header(
                pageNumber: _currentPage + 1,
                onSkip: _goToSignUp,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      page: onboardingPages[index],
                    );
                  },
                ),
              ),
              _Footer(
                currentPage: _currentPage,
                isLastPage: _isLastPage,
                onPrevious: _previousPage,
                onNext: _nextPage,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.pageNumber,
    required this.onSkip,
  });

  final int pageNumber;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$pageNumber',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '/${onboardingPages.length}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.page,
  });

  final Onboarding page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          page.image,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 32),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          page.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.currentPage,
    required this.isLastPage,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final bool isLastPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed:
                  currentPage == 0 ? null : onPrevious,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                disabledForegroundColor:
                    Colors.transparent,
              ),
              child: const Text(
                'Prev',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            onboardingPages.length,
            (index) => _PageDot(
              isActive: index == currentPage,
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onNext,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Text(
                isLastPage ? 'Get Started' : 'Next',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFFFF3B61),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: isActive ? 35 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF172033)
            : const Color(0xFFD6D8DE),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}