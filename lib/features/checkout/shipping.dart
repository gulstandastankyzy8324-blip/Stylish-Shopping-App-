import 'package:flutter/material.dart';
import '../success/success.dart';

class ShippingScreen extends StatefulWidget {
  final double total;

  const ShippingScreen({
    super.key,
    this.total = 84.00,
  });

  @override
  State<ShippingScreen> createState() =>
      _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  String selectedPayment = 'Visa';
  bool isPaying = false;

  Future<void> payNow() async {
    setState(() {
      isPaying = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Order',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '\$${(widget.total - 5).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Shipping',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              '\$5.00',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 22,
              ),
              child: Divider(),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            paymentCard(
              name: 'Visa',
              number: '************2109',
              icon: Icons.credit_card,
            ),
            const SizedBox(height: 12),
            paymentCard(
              name: 'MasterCard',
              number: '************2109',
              icon: Icons.payment,
            ),
            const SizedBox(height: 12),
            paymentCard(
              name: 'PayPal',
              number: 'user@email.com',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    isPaying ? null : payNow,
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
                  child: isPaying
                      ? const SizedBox(
                          key: ValueKey('paying'),
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Continue  \$${widget.total.toStringAsFixed(2)}',
                          key: const ValueKey(
                            'continue',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentCard({
    required String name,
    required String number,
    required IconData icon,
  }) {
    final selected =
        selectedPayment == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = name;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF0F3)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF3B61)
                : const Color(0xFFE3E3E3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF3B61),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: name,
              groupValue: selectedPayment,
              activeColor:
                  const Color(0xFFFF3B61),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedPayment = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
