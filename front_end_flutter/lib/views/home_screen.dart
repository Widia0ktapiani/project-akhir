import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String token;

  const HomeScreen({Key? key, required this.username, required this.token})
      : super(key: key);

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
        Uri.parse('http://10.10.11.199:3000/products'),
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
        print('Failed to load products: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  Future<void> _addProduct(String name, int qty, String imageUrl,
      int categoryId, int createdBy) async {
    if (name.isEmpty ||
        qty <= 0 ||
        imageUrl.isEmpty ||
        categoryId <= 0 ||
        createdBy <= 0) {
      print('Invalid input: Ensure all fields are filled correctly.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.10.11.199:3000/products/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': name,
          'qty': qty,
          'imageUrl': imageUrl,
          'categoryId': categoryId,
          'createdBy': createdBy,
        }),
      );

      if (response.statusCode == 201) {
        print('Product added successfully.');
        _showMessageDialog('Success', 'Product added successfully.');
        _fetchProducts();
      } else {
        print('Failed to add product: ${response.body}');
        _showMessageDialog('Failed!', 'Failed to add product.');
      }
    } on http.ClientException catch (e) {
      print('Client error: $e');
      _showMessageDialog('Error', 'Client error: $e');
    } catch (e) {
      print('Error adding product: $e');
      _showMessageDialog('Error', 'Error adding product: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProduct(int id, String name, int qty, String imageUrl,
      int categoryId, int updatedBy) async {
    if (name.isEmpty ||
        qty <= 0 ||
        imageUrl.isEmpty ||
        categoryId <= 0 ||
        updatedBy <= 0) {
      print('Invalid input');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://10.10.11.199:3000/products/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'name': name,
          'qty': qty,
          'imageUrl': imageUrl,
          'categoryId': categoryId,
          'updatedBy': updatedBy,
        }),
      );

      if (response.statusCode == 200) {
        _fetchProducts();
        _showMessageDialog('Success', 'Product updated successfully.');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to update product: ${response.body}');
        _showMessageDialog('Failed!', 'Failed to update product.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error updating product: $e');
      _showMessageDialog('Error', 'Error updating product: $e');
    }
  }

  Future<void> _deleteProduct(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('http://10.10.11.199:3000/products/delete/$id'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        _fetchProducts();
        _showMessageDialog('Success', 'Product deleted successfully.');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to delete product: ${response.body}');
        _showMessageDialog('Failed!', 'Failed to delete product.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error deleting product: $e');
      _showMessageDialog('Error', 'Error deleting product: $e');
    }
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5A49B),
          title: Text(title, style: TextStyle(color: Colors.white)),
          content: Text(message, style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
    String name = '';
    int qty = 0;
    String imageUrl = '';
    int categoryId = 0;
    int createdBy = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFF8F0),
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (value) => name = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => qty = int.parse(value),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Image Url',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (value) => imageUrl = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'category ID',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => categoryId = int.parse(value),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'createdBy ID',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => createdBy = int.parse(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addProduct(name, qty, imageUrl, categoryId, createdBy);
                Navigator.of(context).pop();
              },
              child: const Text('add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateProductDialog(int id, String currentName, int currentQty,
      String currentImageUrl, int currentCategoryId, int currentUpdatedBy) {
    String name = currentName;
    int qty = currentQty;
    String imageUrl = currentImageUrl;
    int categoryId = currentCategoryId;
    int updatedBy = currentUpdatedBy;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Product'),
          backgroundColor: Color(0xFFFFF8F0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: qty.toString()),
                  onChanged: (value) => qty = int.parse(value),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Image URL',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  controller: TextEditingController(text: imageUrl),
                  onChanged: (value) => imageUrl = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Category ID',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  controller:
                      TextEditingController(text: categoryId.toString()),
                  onChanged: (value) => categoryId = int.parse(value),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'UpdatedBy ID',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF08073)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF08073), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: updatedBy.toString()),
                  onChanged: (value) => updatedBy = int.parse(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateProduct(id, name, qty, imageUrl, categoryId, updatedBy);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5A49B),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Kembali ke halaman utama atau home
          },
        ),
        centerTitle: true,
        title: Text('My Bouquet'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Fungsi logout di sini
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome, ${widget.username}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
                        color: Color(0xFFFFF8F0),
                        child: ListTile(
                          leading: Image.network(product['imageUrl']),
                          title: Text(product['name']),
                          subtitle: Text('Quantity: ${product['qty']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () => _showProductDetail(product),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _showUpdateProductDialog(
                                  product['id'],
                                  product['name'],
                                  product['qty'],
                                  product['imageUrl'],
                                  product['categoryId'],
                                  product['updatedBy'],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
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
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Pastikan nilai radius cukup besar agar menjadi bulat
                  ),
                  child: Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFF8F0),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
