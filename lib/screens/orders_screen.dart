import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Consumer<Orders>(
                builder: (BuildContext context, value, Widget child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) => OrderItem(value.orders[index]),
                    itemCount: value.orders.length,
                  );
                },
                child: Text('Not fetch yet'));
          }
        }));
  }

//end of =stless
}
