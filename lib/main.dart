import 'package:flutter/material.dart';
import 'Provider/cart_provider.dart';

import 'package:provider/provider.dart';

import 'View/onboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CartProvider cartProvider = CartProvider();
  await cartProvider.initSharedPreferences(); // Initialize SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartProvider),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AppOnBoardPage(),
    );
  }
}
