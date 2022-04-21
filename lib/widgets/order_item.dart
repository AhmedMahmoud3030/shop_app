import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_item.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(15),
              height: min(widget.orderItem.products.length * 20.0 + 70.0, 180),
              child: ListView.builder(
                itemBuilder: (ctx, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderItem.products[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.orderItem.products[index].quantity}x \$${widget.orderItem.products[index].price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )
                  ],
                ),
                itemCount: widget.orderItem.products.length,
              ),
            )
        ],
      ),
    );
  }
}
