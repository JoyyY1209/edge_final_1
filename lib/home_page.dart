import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // API endpoint
  final api = "https://fakestoreapi.com/products";

  // API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      // Parse the response body and update the state
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(products); // For debugging

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(child: const Text('Product Grid')),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              var product = products[index];
              return Container(
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: product['image'],
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "${product['title']}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(child: Text("Product price: \$${product['price']}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                        )),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
