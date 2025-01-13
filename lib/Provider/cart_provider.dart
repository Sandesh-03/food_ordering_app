import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../Model/cart_model.dart';
import '../Model/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  List<Map<String, dynamic>> _orderHistory = [];
  SharedPreferences? _prefs;

  List<CartModel> get carts => _carts;
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  // Initialize SharedPreferences and load stored data
  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await loadCartFromStorage(); // Load cart data
    await loadOrderHistoryFromStorage(); // Load order history
  }

  // Save cart data to SharedPreferences
  void saveCartToStorage() {
    if (_prefs != null) {
      String cartData = jsonEncode(
        _carts.map((cart) => {
          "product": {
            "name": cart.productModel.name,
            "image": cart.productModel.image,
            "price": cart.productModel.price,
            "rate": cart.productModel.rate,
            "distance": cart.productModel.distance,
            "category": cart.productModel.category,
          },
          "quantity": cart.quantity,
        }).toList(),
      );
      _prefs!.setString('cartData', cartData);
      debugPrint("Cart saved: $cartData"); // Debugging statement
    }
  }

  // Save order history to SharedPreferences
  void saveOrderHistoryToStorage() {
    if (_prefs != null) {
      String orderHistoryData = jsonEncode(_orderHistory);
      _prefs!.setString('orderHistory', orderHistoryData);
      debugPrint("Order history saved: $orderHistoryData"); // Debugging statement
    }
  }

  // Load cart data from SharedPreferences
  Future<void> loadCartFromStorage() async {
    if (_prefs != null) {
      String? cartData = _prefs!.getString('cartData');
      if (cartData != null) {
        List<dynamic> jsonCart = jsonDecode(cartData);
        _carts = jsonCart.map((item) {
          MyProductModel product = MyProductModel(
            name: item["product"]["name"],
            image: item["product"]["image"],
            price: item["product"]["price"],
            rate: item["product"]["rate"],
            distance: item["product"]["distance"],
            category: item["product"]["category"],
          );
          return CartModel(productModel: product, quantity: item["quantity"]);
        }).toList();
        debugPrint("Cart loaded: $cartData"); // Debugging statement
        notifyListeners();
      }
    }
  }

  // Load order history from SharedPreferences
  Future<void> loadOrderHistoryFromStorage() async {
    if (_prefs != null) {
      String? orderHistoryData = _prefs!.getString('orderHistory');
      if (orderHistoryData != null) {
        _orderHistory = List<Map<String, dynamic>>.from(jsonDecode(orderHistoryData));
        debugPrint("Order history loaded: $orderHistoryData"); // Debugging statement
        notifyListeners();
      }
    }
  }

  // Add current cart to order history
  void addOrderToHistory() {
    Map<String, dynamic> order = {
      "items": _carts.map((cart) {
        return {
          "name": cart.productModel.name,
          "price": cart.productModel.price,
          "quantity": cart.quantity,
        };
      }).toList(),
      "total": totalCart(),
      "timestamp": DateTime.now().toString(),
    };

    _orderHistory.add(order); // Add to order history
    saveOrderHistoryToStorage(); // Save to SharedPreferences
    clearCart(); // Clear the cart
  }

  // Add product to cart
  void addCart(MyProductModel productModel) {
    if (productExist(productModel)) {
      int index = _carts.indexWhere((element) => element.productModel == productModel);
      _carts[index].quantity++;
    } else {
      _carts.add(CartModel(productModel: productModel, quantity: 1));
    }
    saveCartToStorage(); // Save changes
    notifyListeners();
  }

  // Reduce product quantity in cart
  void reduceQuantity(MyProductModel productModel) {
    int index = _carts.indexWhere((element) => element.productModel == productModel);
    if (index != -1) {
      if (_carts[index].quantity > 1) {
        _carts[index].quantity--;
      } else {
        _carts.removeAt(index);
      }
      saveCartToStorage(); // Save changes
      notifyListeners();
    }
  }

  // Check if product exists in cart
  bool productExist(MyProductModel productModel) {
    return _carts.any((element) => element.productModel == productModel);
  }

  // Calculate total price of the cart
  double totalCart() {
    return _carts.fold(0, (sum, cart) => sum + cart.quantity * cart.productModel.price);
  }

  // Clear cart
  void clearCart() {
    _carts.clear();
    _prefs?.remove('cartData'); // Clear from SharedPreferences
    notifyListeners();
  }
}
