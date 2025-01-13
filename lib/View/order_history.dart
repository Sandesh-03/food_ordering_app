import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_provider.dart';
import '../consts.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    List<Map<String, dynamic>> orderHistory = cartProvider.orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: kblack,
      ),
      body: orderHistory.isEmpty
          ? const Center(
              child: Text(
                "No orders yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                final items = order["items"] as List<dynamic>;
                final total = order["total"] as double;
                final timestamp = order["timestamp"] as String;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Date: ${DateTime.parse(timestamp).toLocal()}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...items.map((item) {
                          return Text(
                            "${item["quantity"]}x ${item["name"]} - \$${item["price"]}",
                            style: const TextStyle(fontSize: 14),
                          );
                        }).toList(),
                        const Divider(),
                        Text(
                          "Total: \$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: korange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
