import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/cart_model.dart';
import 'models/model_api.dart';
import 'base_network.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartModel> cartBox;
  late Box<CartModel> purchaseBox;
  late double totalCartPrice;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartModel>('cartBox');
    purchaseBox = Hive.box<CartModel>('purchaseBox');
    fetchData();
  }

  final ApiClient apiClient = ApiClient();
  late List<Products> products;

  Future<void> fetchData() async {
    try {
      final data = await apiClient.fetchProduct();
      final productModel = ProductsModel.fromJson(data);
      setState(() {
        products = productModel.products ?? [];
      });
      updateTotalPrice(); // Initial calculation
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  double roundRating(double rating) {
    if (rating < 5 && rating > 4.5) {
      return (rating * 2).floor() / 2; // Round up
    } else if (rating < 4.3) {
      return rating.floorToDouble(); // Round down
    } else {
      return (rating * 2).round() / 2; // Round to the nearest 0.5
    }
  }

  void removeItem(CartModel cartItem) {
    cartBox.delete(cartItem.idProduct);
    updateTotalPrice();
  }

  void increaseQuantity(CartModel cartItem) {
    cartItem.quantity += 1;
    cartBox.put(cartItem.idProduct, cartItem);
    updateTotalPrice();
  }

  void decreaseQuantity(CartModel cartItem) {
    if (cartItem.quantity > 0) {
      cartItem.quantity -= 1;
      if (cartItem.quantity == 0) {
        _showRemoveConfirmation(cartItem);
      } else {
        cartBox.put(cartItem.idProduct, cartItem);
        updateTotalPrice();
      }
    }
  }

  Future<void> _showRemoveConfirmation(CartModel cartItem) async {
    bool? removeConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove from Cart?'),
          content: Text('Do you want to remove this item from the cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when removed
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );

    if (removeConfirmed == true) {
      removeItem(cartItem);
    } else {
      // If canceled, increment the quantity back to its previous value
      cartItem.quantity += 1;
      cartBox.put(cartItem.idProduct, cartItem);
      updateTotalPrice();
    }
  }

  Future<void> _showCheckoutConfirmation() async {
    bool? checkoutConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Checkout'),
          content: Text('Do you want to proceed with the checkout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when confirmed
              },
              child: Text('Checkout'),
            ),
          ],
        );
      },
    );

    if (checkoutConfirmed == true) {
      // Move items from cartBox to purchaseBox
      for (var cartItem in cartBox.values.toList()) {
        // Create a new instance of CartModel
        final newCartItem = CartModel(
          idProduct: cartItem.idProduct,
          quantity: cartItem.quantity,
          // Copy other necessary fields
        );

        purchaseBox.put(newCartItem.idProduct, newCartItem);
      }

      // Clear the cartBox
      cartBox.clear();

      // Update total cart price
      updateTotalPrice();
    }
  }

  void updateTotalPrice() {
    // Recalculate total cart price
    totalCartPrice = cartBox.values.fold<double>(0, (previousValue, cartItem) {
        final foundProduct = products.firstWhere(
              (product) => product.id == cartItem.idProduct,
        );
        return previousValue +
            (foundProduct.price! - (foundProduct.price! * foundProduct.discountPercentage! / 100)) * cartItem.quantity;
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, box, _) {
          final List<CartModel> cartProducts = box.values.toList();
          if (cartProducts.isEmpty) {
            return Center(
              child: Text('Shopping Cart is Empty.'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      CartModel cart = cartProducts[index];
                      Products foundProduct = products.firstWhere(
                            (product) => product.id == cart.idProduct,
                      );
                      double totalPrice =
                          (foundProduct.price! - (foundProduct.price! * foundProduct.discountPercentage! / 100)) * cart.quantity;

                      return Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.network('${foundProduct.thumbnail}', height: 120, width: 120),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${foundProduct.title}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          '\$ ${(foundProduct.price! - (foundProduct.price! * foundProduct.discountPercentage! / 100)).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                decreaseQuantity(cart);
                                              },
                                            ),
                                            Container(
                                              width: 30,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                controller: TextEditingController(text: '${cart.quantity}'),
                                                enabled: false,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.grey[800]!),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                increaseQuantity(cart);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '\$ ${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Display total cart price and checkout button
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$ ${totalCartPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showCheckoutConfirmation();
                      },
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
