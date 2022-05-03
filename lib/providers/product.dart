import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken) async {
    final _oldIsFavoriteStatus = isFavorite;
    final Uri url = Uri.parse(
        'https://shopapp-cc7bd-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response=await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if(response.statusCode>=400){
        isFavorite=_oldIsFavoriteStatus;
        notifyListeners();
        throw response;
      }
    } catch (_) {

    }
  }
}
