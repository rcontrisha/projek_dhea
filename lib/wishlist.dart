import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/wishlist_model.dart';
import 'base_network.dart';
import 'detail.dart';
import 'models/model_api.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Box<WishlistModel> wishlistBox;

  @override
  void initState() {
    super.initState();
    wishlistBox = Hive.box<WishlistModel>('wishlistBox');
    print(wishlistBox.values);
    fetchData();// Print all values in the favorites box
  }

  final ApiClient apiClient = ApiClient();
  late List<Products> products;

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
        title: Text('Wish List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: wishlistBox.listenable(),
        builder: (context, box, _) {
          final List<WishlistModel> wishProducts = box.values.toList();
          if (wishProducts.isEmpty) {
            return Center(
              child: Text('No wish list yet.'),
            );
          }
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.77
              ),
              itemCount: wishProducts.length,
              itemBuilder: (context, index) {
                WishlistModel wishlist = wishProducts[index];
                Products foundProduct = products.firstWhere(
                      (product) => product.id == wishlist.idProduct,
                );
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProduct(products: foundProduct)));
                    },
                    child: Column(
                      children: [
                        Flexible(
                          child: Container(
                              height: 150,
                              width: 200,
                              child: Image.network('${foundProduct.thumbnail}', fit: BoxFit.cover)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Text(
                                    '${foundProduct.title}',
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
                                  '\$ ${foundProduct.price}',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(width: 110),
                                Text(
                                  '-${foundProduct.discountPercentage!.round()}%',
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
                                  initialRating: roundRating(foundProduct.rating!),
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
                                    '  (${foundProduct.rating})',
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
          );
        },
      ),
    );
  }
}