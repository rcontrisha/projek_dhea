import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/cart_model.dart';
import '../models/wishlist_model.dart';
import 'login.dart';
import 'models/todo_model.dart';


String boxName = 'TODOBOX';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<TodoModel>(TodoModelAdapter());
  Hive.registerAdapter<WishlistModel>(WishlistModelAdapter());
  Hive.registerAdapter<CartModel>(CartModelAdapter());
  await Hive.openBox<TodoModel>(boxName);
  await Hive.openBox<WishlistModel>('wishlistBox');
  await Hive.openBox<CartModel>('cartBox');
  await Hive.openBox<CartModel>('purchaseBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the primary color
        backgroundColor: Colors.white, // Set the background color
      ),
      home: LoginForm(),
    );
  }
}
