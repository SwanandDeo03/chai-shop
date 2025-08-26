import 'order_item.dart';

enum OrderStatus { pending, confirmed, preparing, ready, delivered, cancelled }

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime orderTime;
  OrderStatus status;
  final String customerName;
  final String customerPhone;
  String? notes;

  Order({
    required this.id,
    required this.items,
    required this.orderTime,
    this.status = OrderStatus.pending,
    required this.customerName,
    required this.customerPhone,
    this.notes,
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  String get statusString {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'orderTime': orderTime.toIso8601String(),
      'status': status.index,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderTime: DateTime.parse(json['orderTime']),
      status: OrderStatus.values[json['status']],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      notes: json['notes'],
    );
  }
}
