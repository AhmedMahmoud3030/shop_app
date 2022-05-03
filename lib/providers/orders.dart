import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/order_item.dart';

import 'cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> porders = [];
  final String authToken;
  Orders({this.authToken, this.porders});

  List<OrderItem> get orders {
    return [...porders];
  }

  Future<void> fetchAndSetOrders() async {
    final Uri url =
        Uri.parse('https://shopapp-cc7bd-default-rtdb.firebaseio.com/orders.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if(extractData==null){
        return;
      }
      extractData.forEach((key, value) {
        loadedOrders.add(
          OrderItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>).map((e) => CartItem(
                title: e['title'],
                id: e['id'],
                price: e['price'],
                quantity: e['quantity'])).toList(),
          ),
        );
        porders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final Uri url =
        Uri.parse('https://shopapp-cc7bd-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    try {
      final respone = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'title': e.title,
                    'quantity': e.quantity,
                  })
              .toList()
        }),
      );
      porders.insert(
        0,
        OrderItem(
          id: json.decode(respone.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();

      if (respone.statusCode >= 400) {}
    } catch (error) {}
  }
}
