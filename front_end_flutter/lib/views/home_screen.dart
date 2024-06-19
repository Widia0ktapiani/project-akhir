import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String username;
  final String token;

  const HomeScreen({Key? key, required this.username, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.10.11.182:3000/products'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _products = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // handle error
        print('Failed to load products: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  Future<void> _addProduct(String name, int qty, String imageUrl, int categoryId) async {
    if (name.isEmpty || qty <= 0 || imageUrl.isEmpty || categoryId <= 0) {
      print('Invalid input');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.10.11.182:3000/products/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': name,
          'qty': qty,
          'imageUrl': imageUrl,
          'categoryId': categoryId,
          'createdBy': widget.username,
        }),
      );

      if (response.statusCode == 201) {
        _fetchProducts();
      } else {
        setState(() {
          _isLoading = false;
        });
        // handle error
        print('Failed to add product: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error adding product: $e');
    }
  }

  Future<void> _updateProduct(int id, String name, int qty, String imageUrl, int categoryId) async {
    if (name.isEmpty || qty <= 0 || imageUrl.isEmpty || categoryId <= 0) {
      print('Invalid input');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://10.10.11.182:3000/products/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': name,
          'qty': qty,
          'imageUrl': imageUrl,
          'categoryId': categoryId,
          'updatedBy': widget.username,
        }),
      );

      if (response.statusCode == 200) {
        _fetchProducts();
      } else {
        setState(() {
          _isLoading = false;
        });
        // handle error
        print('Failed to update product: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error updating product: $e');
    }
  }

  Future<void> _deleteProduct(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('http://10.10.11.182:3000/products/delete/$id'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        _fetchProducts();
      } else {
        setState(() {
          _isLoading = false;
        });
        // handle error
        print('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error deleting product: $e');
    }
  }

  void _showAddProductDialog() {
    String name = '';
    int qty = 0;
    String imageUrl = '';
    int categoryId = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) => qty = int.tryParse(value) ?? 0,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Image URL'),
                onChanged: (value) => imageUrl = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Category ID'),
                keyboardType: TextInputType.number,
                onChanged: (value) => categoryId = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addProduct(name, qty, imageUrl, categoryId);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateProductDialog(int id, String currentName, int currentQty, String currentImageUrl, int currentCategoryId) {
    String name = currentName;
    int qty = currentQty;
    String imageUrl = currentImageUrl;
    int categoryId = currentCategoryId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Name'),
                controller: TextEditingController(text: name),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Quantity'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: qty.toString()),
                onChanged: (value) => qty = int.tryParse(value) ?? currentQty,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Image URL'),
                controller: TextEditingController(text: imageUrl),
                onChanged: (value) => imageUrl = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Category ID'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: categoryId.toString()),
                onChanged: (value) => categoryId = int.tryParse(value) ?? currentCategoryId,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateProduct(id, name, qty, imageUrl, categoryId);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(product['imageUrl']),
              Text('Quantity: ${product['qty']}'),
              Text('Category ID: ${product['categoryId']}'),
              Text('Created By: ${product['createdBy']}'),
              Text('Updated By: ${product['updatedBy']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('http://example.com/userimage'), // Ganti URL dengan URL gambar pengguna
                  ),
                  title: Text(widget.username),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        elevation: 3,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(product['imageUrl']),
                                                    title: Text(product['name']),
                          subtitle: Text('Qty: ${product['qty']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () => _showProductDetail(product),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showUpdateProductDialog(
                                  product['id'],
                                  product['name'],
                                  product['qty'],
                                  product['imageUrl'],
                                  product['categoryId'],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteProduct(product['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FloatingActionButton(
                  onPressed: _showAddProductDialog,
                  child: Icon(Icons.add),
                ),
              ],
            ),
    );
  }
}

                         
