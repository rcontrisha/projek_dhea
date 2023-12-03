import 'package:hive/hive.dart';

part 'wishlist_model.g.dart';
@HiveType(typeId:1)

class WishlistModel extends HiveObject{
  @HiveField(0)
  late int idProduct;

  @HiveField(1)
  late bool isFavorite;

  WishlistModel({
    required this.idProduct,
    required this.isFavorite,
  });
}