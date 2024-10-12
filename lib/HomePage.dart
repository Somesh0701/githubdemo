import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> products = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      products.clear();
      String? savedProducts = prefs.getString('products');
      if (savedProducts != null) {
        products.addAll(List<Map<String, dynamic>>.from(json.decode(savedProducts)));
      }
    });
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product name and price are required!')),
      );
      return;
    }

    final newProduct = {
      'name': _nameController.text,
      'price': _priceController.text,
    };

    if (products.any((product) => product['name'] == newProduct['name'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product already exists!')),
      );
      return;
    }

    products.add(newProduct);
    _saveProducts();
    _nameController.clear();
    _priceController.clear();
    setState(() {});
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('products', json.encode(products));
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      _saveProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Search Products'),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No Product Found'))
                : ListView.builder(
              itemCount: products
                  .where((product) => product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                final filteredProducts = products
                    .where((product) => product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();
                return ListTile(
                  title: Text(filteredProducts[index]['name']),
                  subtitle: Text('\$${filteredProducts[index]['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteProduct(products.indexOf(filteredProducts[index])),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addProduct();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}