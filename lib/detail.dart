import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:projectakhirr/cart.dart';
import '../models/cart_model.dart';
import '../models/model_api.dart';
import '../models/wishlist_model.dart';

class DetailProduct extends StatefulWidget {
  late final Products products;

  DetailProduct({required this.products});

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late final PageController controller;
  late Box<WishlistModel> wishlistBox;
  late Box<CartModel> cartBox;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    wishlistBox = Hive.box<WishlistModel>('wishlistBox');
    cartBox = Hive.box<CartModel>('cartBox');
  }

  bool isFavorite(int idProduct) {
    return wishlistBox.containsKey(idProduct);
  }

  void toggleFavorite(BuildContext context) {
    final int idProduct = widget.products.id!;
    if (isFavorite(idProduct)) {
      wishlistBox.delete(idProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from favorites'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      wishlistBox.put(
        idProduct,
        WishlistModel(idProduct: idProduct, isFavorite: true),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to favorites'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
    setState(() {});
  }

  Future<bool> _addToCartWithConfirmation(BuildContext context, int idProduct) async {
    bool addToCartConfirmed = await showConfirmationDialog(context, 'Add to Cart');

    if (addToCartConfirmed) {
      cartBox.put(idProduct, CartModel(idProduct: idProduct, quantity: 1));
      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
    }

    return addToCartConfirmed;
  }

  Future<bool> showConfirmationDialog(BuildContext context, String action) async {
    return (await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if cancelled
              },
              child: Text('No'),
            ),
          ],
        );
      },
    )) ?? false; // Provide a default value of false if the result is null
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
        title: Text('${widget.products.title}'),
        actions: [
          IconButton(
              onPressed: () {
                _addToCartWithConfirmation(context, widget.products.id!);
              },
              icon: Icon(Icons.add_shopping_cart)
          ),
          IconButton(
            onPressed: () => toggleFavorite(context),
            icon: Icon(
              isFavorite(widget.products.id!)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavorite(widget.products.id!)
                  ? Colors.redAccent
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 250,
                child: PageView.builder(
                  controller: controller,
                  itemCount: widget.products.images?.length ?? 0,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final data = widget.products.images?[index];
                    if (data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Card(
                        child: Image.network(
                          '${data}' ?? '',
                          fit: BoxFit.fill,
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.products.title}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.bookmark, color: Colors.amber, size: 45,),
                        Column(
                          children: [
                            Text(
                              '${widget.products.discountPercentage!.round()}%',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              'OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                        child: Icon(Icons.storefront, size: 20, color: Colors.white),
                        radius: 15,
                        backgroundColor: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                        '${widget.products.brand}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$ ${(widget.products.price! - (widget.products.price! * widget.products.discountPercentage! / 100)).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '\$ ${widget.products.price}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    RatingBar.builder(
                      initialRating: roundRating(widget.products.rating!),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                      ignoreGestures: true,
                    ),
                    Text(
                        '   (${widget.products.rating})',
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: 14)
                    ),
                    Text('    |    '),
                    Text(
                      'Stock: ${widget.products.stock}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Product Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700]
                        ),
                    ),
                    Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                        side: BorderSide(color: Colors.grey[700]!), // Set border color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${widget.products.description}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
