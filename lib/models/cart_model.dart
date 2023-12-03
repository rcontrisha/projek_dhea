import 'package:hive/hive.dart';

part 'cart_model.g.dart';
@HiveType(typeId:2)

class CartModel extends HiveObject{
  @HiveField(0)
  late int idProduct;

  @HiveField(1)
  late int quantity;

  CartModel({
    required this.idProduct, required this.quantity
  });
}