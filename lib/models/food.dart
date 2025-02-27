class FoodItem {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final double price;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    this.description,
    this.category,
    required this.price,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.isAvailable = true,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return FoodItem(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      category: map['category'],
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount']?.toInt(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String foodType;
  final String image;
  final String rate;
  final String rating;
  final String type;

  ProductModel({
    this.id = '', //  
    required this.name,
    required this.foodType,
    required this.image,
    required this.rate,
    required this.rating,
    required this.type,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      foodType: map['foodType'] ?? '',
      image: map['image'] ?? '',
      rate: map['rate'] ?? '',
      rating: map['rating'] ?? '',
      type: map['type'] ?? '',
    );
  }

  ProductModel copyWith({String? id}) {
    return ProductModel(
      id: id ?? this.id,
      name: name,
      foodType: foodType,
      image: image,
      rate: rate,
      rating: rating,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodType': foodType,
      'image': image,
      'rate': rate,
      'rating': rating,
      'type': type,
    };
  }
}
