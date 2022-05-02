// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

import '../providers/cart.dart' show Cart;

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed:(cart.totalAmount<=0||_isLoading)?null: () async{
                      setState(() {
                        _isLoading=true;

                      });
                     await Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,

                      );
                     setState(() {
                       _isLoading=false;
                     });
                      cart.clearCart();
                    },
                    child:_isLoading?CircularProgressIndicator(): Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => ci.CartItem(
                productId: cart.items.keys.toList()[index],
                quantity: cart.items.values.toList()[index].quantity,
                price: cart.items.values.toList()[index].price,
                title: cart.items.values.toList()[index].title,
                id: cart.items.values.toList()[index].id),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
