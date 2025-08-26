import 'package:flutter/material.dart';
import 'dart:math';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum PaymentMethod { cash, card, upi }

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  PaymentMethod _method = PaymentMethod.card;
  bool _processing = false;

  final _nameCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  final List<_CartItem> _cart = const [
    _CartItem(name: 'Chai', qty: 2, price: 2.5),
    _CartItem(name: 'Shakes', qty: 1, price: 4.0),
  ];

  double get _total => _cart.fold(0.0, (s, i) => s + i.price * i.qty);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  String _generateOrderId() {
    final rand = Random();
    final n = List.generate(4, (_) => rand.nextInt(10)).join();
    return 'ORD$n';
  }

  Future<void> _pay() async {
    if (_method == PaymentMethod.card) {
      if (!_formKey.currentState!.validate()) return;
    }

    setState(() => _processing = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      final orderId = _generateOrderId();
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('✅ Payment successful'),
          content: Text(
            'Order $orderId\nTotal: \$${_total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/orders', (route) => false);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Widget _buildCardForm() {
    InputDecoration deco(String label) => InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: deco('Name on card'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cardCtrl,
            keyboardType: TextInputType.number,
            decoration: deco('Card number'),
            maxLength: 19,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter card number';
              final digits = v.replaceAll(RegExp(r'\s+'), '');
              if (digits.length < 13 || digits.length > 19) {
                return 'Enter a valid card number';
              }
              if (!RegExp(r'^\d+$').hasMatch(digits)) {
                return 'Invalid card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryCtrl,
                  decoration: deco('Expiry (MM/YY)'),
                  maxLength: 5,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter expiry';
                    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(v)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvCtrl,
                  decoration: deco('CVV'),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter CVV';
                    if (!RegExp(r'^\d{3,4}$').hasMatch(v)) return 'Invalid CVV';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ..._cart.map((c) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${c.qty} × ${c.name}'),
                  trailing: Text(
                    '\$${(c.price * c.qty).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummary(),
                const SizedBox(height: 20),
                Text('Payment method',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      RadioListTile<PaymentMethod>(
                        value: PaymentMethod.card,
                        groupValue: _method,
                        title: const Text('💳 Card'),
                        subtitle: const Text('Pay with debit/credit card'),
                        onChanged: (v) => setState(() => _method = v!),
                      ),
                      RadioListTile<PaymentMethod>(
                        value: PaymentMethod.upi,
                        groupValue: _method,
                        title: const Text('📱 UPI'),
                        subtitle: const Text('Pay using UPI app'),
                        onChanged: (v) => setState(() => _method = v!),
                      ),
                      RadioListTile<PaymentMethod>(
                        value: PaymentMethod.cash,
                        groupValue: _method,
                        title: const Text('💵 Cash'),
                        subtitle: const Text('Pay on delivery'),
                        onChanged: (v) => setState(() => _method = v!),
                      ),
                    ],
                  ),
                ),
                if (_method == PaymentMethod.card) ...[
                  const SizedBox(height: 16),
                  _buildCardForm(),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _processing ? null : _pay,
                    child: Text(
                      _processing
                          ? 'Processing...'
                          : 'Pay \$${_total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_processing)
            const ModalBarrier(dismissible: false, color: Colors.black26),
          if (_processing) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class _CartItem {
  final String name;
  final int qty;
  final double price;
  const _CartItem({required this.name, required this.qty, required this.price});
}
