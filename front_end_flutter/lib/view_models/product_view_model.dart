import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductViewModel {
  final String token;
  final String username;

  ProductViewModel({required this.token, required this.username});

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('http://10.10.11.182:3000/products'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('http://10.10.11.182:3000/products/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('http://10.10.11.182:3000/products/update/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.10.11.182:3000/products/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
