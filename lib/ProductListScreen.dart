import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Productlistscreen extends StatelessWidget {
  final List<Product> products = [
    Product(id: 'HeadPhone', name: 'Product 1', price: 25),
    Product(id: 'Cable',     name: 'Product 2', price: 25),
    Product(id: 'Charger',   name: 'Product 3', price: 25),
  ];
   Productlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price}'),
            onTap: () {
              // Navigate to product detail page if needed
            },
          );
        },
      ),
    );
  }
}
