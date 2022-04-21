import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartItemQuantities {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }
  void clearCart(){
    _items={};
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          title: value.title,
          id: value.id,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          title: title,
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
