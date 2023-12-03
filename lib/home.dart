import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectakhirr/cart.dart';
import '../currency.dart';
import '../detail.dart';
import '../login.dart';
import '../profile.dart';
import '../wishlist.dart';
import 'base_network.dart';
import 'models/model_api.dart';


class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final ApiClient apiClient = ApiClient();
  late List<Products> products;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the method to fetch data when the page is initialized
  }

  Future<void> fetchData() async {
    try {
      final data = await apiClient.fetchProduct();
      final productModel = ProductsModel.fromJson(data); // Assuming you have a TeamModel model class

      setState(() {
        products = productModel.products ?? [];
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, show a message to the user, or retry the request
    }
  }

  void _navigateToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: widget.username,
          nim: '124210018', // Ganti dengan NIM sesuai kebutuhan
          kesan: 'Ini adalah kesan saya.',
          pesan: 'Ini adalah pesan saya.',
        ),
      ),
    );
  }

  double roundRating(double rating) {
    if (rating < 5 && rating > 4.5) {
      return (rating * 2).floor() / 2; // Round up
    } else if (rating < 4.3) {
      return rating.floorToDouble(); // Round down
    } else {
      // Round to the nearest 0.5
      return (rating * 2).round() / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
              icon: Icon(Icons.shopping_cart)
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage()));
              },
              icon: Icon(Icons.favorite_border)
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                    'Welcome, ${widget.username}!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                    ),
                ),
                SizedBox(width: 5),
                Icon(Icons.waving_hand, color: Colors.amber)
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.77
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProduct(products: product)));
                      },
                      child: Column(
                        children: [
                          Flexible(
                            child: Container(
                              height: 150,
                              width: 200,
                              child: Image.network('${product.thumbnail}', fit: BoxFit.cover)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Align(
                              alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Text(
                                        '${product.title}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14
                                        ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '\$ ${product.price}',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 110),
                                  Text(
                                    '-${product.discountPercentage!.round()}%',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 2
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: roundRating(product.rating!),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 13,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                    ignoreGestures: true,
                                  ),
                                  Text(
                                    '  (${product.rating})',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 11)
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5)
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.autorenew, color: Colors.grey),
            label: 'Convert',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.grey),
            label: 'Log Out',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CurrencyConverter()));
      } else if (index == 2) {
        _navigateToProfilePage();
      } else if (index == 3) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginForm()));
      }
    });
  }
}



class Product {
  final int? id;
  final String? title;

  Product({
    this.id,
    this.title,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
    );
  }
}
