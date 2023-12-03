class ProductsModel {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  ProductsModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ProductsModel.fromJson(Map<String, dynamic> json) {
    products = (json['products'] as List?)?.map((dynamic e) => Products.fromJson(e as Map<String,dynamic>)).toList();
    total = json['total'] as int?;
    skip = json['skip'] as int?;
    limit = json['limit'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['products'] = products?.map((e) => e.toJson()).toList();
    json['total'] = total;
    json['skip'] = skip;
    json['limit'] = limit;
    return json;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Products({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    price = json['price'] as int?;
    discountPercentage = json['discountPercentage'] as double?;
    rating = json['rating'] as double?;
    stock = json['stock'] as int?;
    brand = json['brand'] as String?;
    category = json['category'] as String?;
    thumbnail = json['thumbnail'] as String?;
    images = (json['images'] as List?)?.map((dynamic e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['price'] = price;
    json['discountPercentage'] = discountPercentage;
    json['rating'] = rating;
    json['stock'] = stock;
    json['brand'] = brand;
    json['category'] = category;
    json['thumbnail'] = thumbnail;
    json['images'] = images;
    return json;
  }
}