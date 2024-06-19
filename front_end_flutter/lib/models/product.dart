class Product {
  final int id;
  final String name;
  final int qty;
  final String imageUrl;
  final int categoryId;
  final String createdBy;
  final String updatedBy;

  Product({
    required this.id,
    required this.name,
    required this.qty,
    required this.imageUrl,
    required this.categoryId,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
