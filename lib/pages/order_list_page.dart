import 'package:flutter/material.dart';

// ---------------- Models ----------------
class Order {
  final int id;
  final List<OrderItem> items;
  const Order(this.id, this.items);

  String get itemsSummary =>
      items.map((it) => '${it.qty}× ${it.name}').join(', ');
  int get itemCount => items.fold(0, (sum, it) => sum + it.qty);
  double get total =>
      items.fold(0.0, (sum, it) => sum + it.price * it.qty);
}

class OrderItem {
  final String name;
  final int qty;
  final double price;
  const OrderItem(this.name, this.qty, this.price);
}

// ---------------- Service ----------------
class OrderService {
  OrderService._();
  static final instance = OrderService._();

  final ValueNotifier<List<Order>> orders = ValueNotifier<List<Order>>([]);

  void addOrder(Order order) {
    orders.value = List<Order>.from(orders.value)..add(order);
  }

  void clear() => orders.value = [];

  void removeById(int id) {
    orders.value =
        List<Order>.from(orders.value)..removeWhere((o) => o.id == id);
  }
}

// ---------------- Order List Page ----------------
class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final greyBg = Colors.grey.shade100;
    final cardColor = Colors.grey.shade300;

    return Scaffold(
      backgroundColor: greyBg,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () => OrderService.instance.clear(),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Order>>(
        valueListenable: OrderService.instance.orders,
        builder: (context, orders, _) {
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders yet',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final o = orders[i];
              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Order #${o.id}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      '${o.itemsSummary}\nItems: ${o.itemCount}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${o.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            OrderService.instance.removeById(o.id),
                      ),
                    ],
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: Text(
                        'Order #${o.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        o.items
                            .map((it) =>
                                '${it.qty}× ${it.name} — \$${(it.price * it.qty).toStringAsFixed(2)}')
                            .join('\n'),
                        style: const TextStyle(fontSize: 14),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        tooltip: "Simulate New Order",
        onPressed: () {
          final newOrder = Order(
            DateTime.now().millisecondsSinceEpoch,
            [
              const OrderItem("Chai", 2, 2.5),
              const OrderItem("Coffee", 1, 3.0),
            ],
          );
          OrderService.instance.addOrder(newOrder);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
