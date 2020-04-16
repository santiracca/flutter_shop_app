import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final isLoading = Provider.of<Orders>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  isLoading
                      ? Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              child: CircularProgressIndicator()),
                        )
                      : FlatButton(
                          child: Text(
                            'ORDER  NOW',
                          ),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: cart.items.length == 0
                              ? null
                              : () async {
                                  try {
                                    await Provider.of<Orders>(context,
                                            listen: false)
                                        .addOrder(cart.items.values.toList(),
                                            cart.totalAmount);
                                    cart.clear();
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                        )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title),
            ),
          )
        ],
      ),
    );
  }
}
