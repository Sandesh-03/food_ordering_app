import 'package:animate_do/animate_do.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_provider.dart';
import '../consts.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    double deliveryFee = 5.99;
    double total = cartProvider.totalCart();
    double payable = total + deliveryFee;

    return Scaffold(
      backgroundColor: kbgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back, color: kblack),
                    ),
                  ),
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      color: kblack,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(), // Spacer for alignment
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ...List.generate(
                      cartProvider.carts.length,
                      (index) => FadeInUp(
                        delay: Duration(milliseconds: (index + 1) * 200),
                        child: ListTile(
                          leading: Image.asset(
                            cartProvider.carts[index].productModel.image,
                            width: 50,
                          ),
                          title: Text(
                            cartProvider.carts[index].productModel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${cartProvider.carts[index].quantity} x \$${cartProvider.carts[index].productModel.price.toStringAsFixed(2)}",
                          ),
                          trailing: Text(
                            "\$${(cartProvider.carts[index].productModel.price * cartProvider.carts[index].quantity).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: korange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Delivery Fee",
                        style: TextStyle(
                          fontSize: 18,
                          color: kblack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: kblack.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "\$${deliveryFee.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: korange,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Total Payable",
                        style: TextStyle(
                          fontSize: 20,
                          color: kblack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: kblack.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "\$${payable.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: korange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      CartProvider cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      cartProvider.addOrderToHistory();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Order Confirmed!")),
                      );

                      Navigator.pop(context); // Navigate back
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: kblack,
                    height: 75,
                    minWidth: MediaQuery.of(context).size.width - 50,
                    child: const Text(
                      "Confirm Order",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
