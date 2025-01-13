import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../Model/product_model.dart';
import '../Provider/cart_provider.dart';
import '../Widgets/food_product_items.dart';
import '../consts.dart';
import 'cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category = "All";
  String searchQuery = "";
  String userLocation = "Fetching location...";
  List<MyProductModel> productModel = myProductModel;
  List<String> categories = []; // To store dynamic categories

  @override
  void initState() {
    super.initState();
    fetchLocation();
    generateCategories(); // Generate categories dynamically
  }

  // Generate unique categories dynamically
  void generateCategories() {
    final Set<String> categorySet = myProductModel
        .map((product) => product.category)
        .toSet(); // Extract unique categories
    setState(() {
      categories = ["All", ...categorySet]; // Add "All" category
    });
  }

  // Fetches the user's current location and gets the city name.
  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          userLocation = "Location not available";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String city = placemarks.first.locality ?? "Unknown City";

      setState(() {
        userLocation = city;
      });
    } catch (e) {
      setState(() {
        userLocation = "Error fetching location";
      });
    }
  }

  // Filters products by category.
  void filterProductByCategory(String selectedCategory) {
    setState(() {
      category = selectedCategory;
      searchQuery = "";
      productModel = selectedCategory == "All"
          ? myProductModel
          : myProductModel
              .where((element) =>
                  element.category.toLowerCase() == selectedCategory.toLowerCase())
              .toList();
    });
  }

  // Filters products by search query.
  void filterProductBySearch(String query) {
    setState(() {
      searchQuery = query;
      category = "All";
      productModel = myProductModel
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Location",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: korange,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            userLocation,
                            style: const TextStyle(
                              fontSize: 16,
                              color: kblack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: kblack,
                        ),
                      ),
                    ),
                    if (cartProvider.carts.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xfff95f60),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cartProvider.carts.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              onChanged: filterProductBySearch,
              decoration: InputDecoration(
                hintText: "Search food by name...",
                prefixIcon: const Icon(Icons.search, color: kblack),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((categoryName) {
                  return GestureDetector(
                    onTap: () => filterProductByCategory(categoryName),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: category == categoryName
                            ? Colors.orange
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange, width: 1),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          color: category == categoryName
                              ? Colors.white
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Result (${productModel.length})",
              style: TextStyle(
                color: kblack.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemCount: productModel.length,
              itemBuilder: (context, index) {
                return FoodProductItems(
                  productModel: productModel[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
