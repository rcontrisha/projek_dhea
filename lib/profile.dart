import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'base_network.dart';
import 'models/cart_model.dart';
import 'models/model_api.dart'; // Import your CartModel class

class ProfilePage extends StatefulWidget {
  final String username;
  final String nim;
  final String kesan;
  final String pesan;

  ProfilePage({
    required this.username,
    required this.nim,
    required this.kesan,
    required this.pesan,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Retrieve the purchaseBox
  final Box<CartModel> purchaseBox = Hive.box<CartModel>('purchaseBox');
  final ApiClient apiClient = ApiClient();
  late List<Products> products;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await apiClient.fetchProduct();
      final productModel = ProductsModel.fromJson(data);
      setState(() {
        products = productModel.products ?? [];
      });
      // Call any other methods or set additional state variables as needed
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${widget.username}'),
            Text('NIM: ${widget.nim}'),
            SizedBox(height: 16),
            Text('Kesan: ${widget.kesan}'),
            Text('Pesan: ${widget.pesan}'),
            SizedBox(height: 16),
            Text(
              'Purchase History:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: purchaseBox.listenable(),
                builder: (context, box, _) {
                  final List<CartModel> purchaseProducts = box.values.toList();
                  if (purchaseProducts.isEmpty) {
                    return Center(
                      child: Text('No Purchased Products Yet.'),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: purchaseProducts.length,
                            itemBuilder: (context, index) {
                              CartModel purchase = purchaseProducts[index];
                              Products foundProduct = products.firstWhere(
                                    (product) => product.id == purchase.idProduct,
                              );
                              double totalPrice = (foundProduct.price! - (foundProduct.price! * foundProduct.discountPercentage! / 100)) * purchase.quantity;

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
                                                Text('x${purchase.quantity}')
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
