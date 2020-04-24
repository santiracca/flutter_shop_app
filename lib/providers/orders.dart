import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  var _isLoading = false;
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-ddc42.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        List<CartItem> orderProducts = [];
        orderData['products'].forEach((val) {
          orderProducts.add(CartItem(
              id: val['id'],
              price: val['price'],
              quantity: val['quantity'],
              title: val['title']));
        });
        loadedOrders.insert(
            0,
            OrderItem(
                id: orderId,
                amount: orderData['amount'],
                dateTime: DateTime.parse(orderData['dateTime']),
                products: orderProducts));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    _isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> products = [];
    cartProducts.forEach((element) {
      products.add({
        'id': element.id,
        'quantity': element.quantity,
        'price': element.price,
        'title': element.title
      });
    });
    final url =
        'https://flutter-shop-app-ddc42.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': products,
            'dateTime': timestamp.toIso8601String(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }
}
