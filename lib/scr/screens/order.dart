import 'package:flutter/material.dart';
import 'package:food_course/scr/helpers/style.dart';
import 'package:food_course/scr/models/order.dart';
import 'package:food_course/scr/providers/app.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Ordenes anteriores"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: user.orders.length,
          itemBuilder: (_, index) {
            OrderModel _order = user.orders[index];
            return ListTile(
              leading: CustomText(
                text: "\$${(_order.total / 100).toStringAsFixed(2)}",
                weight: FontWeight.bold,
              ),
              title: Text(_order.description),
              subtitle: Column(
                children: <Widget>[
                  Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt)
                      .toString()
                      .split('.')[0]),
                ],
              ),
              trailing: CustomText(
                text: _order.status,
                color: green,
              ),
            );
          }),
    );
  }
}
