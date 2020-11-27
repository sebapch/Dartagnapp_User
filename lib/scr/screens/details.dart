import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:food_course/scr/helpers/screen_navigation.dart';
import 'package:food_course/scr/models/products.dart';
import 'package:food_course/scr/providers/app.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/screens/cart.dart';
import 'package:food_course/scr/widgets/custom_text.dart';
import 'package:food_course/scr/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/style.dart';

class Details extends StatefulWidget {
  final ProductModel product;

  const Details({@required this.product});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  String dropdownValue = 'Pepsi';
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              changeScreen(context, CartScreen());
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: app.isLoading
            ? Loading()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(widget.product.image),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomText(
                      text: widget.product.name,
                      size: 26,
                      weight: FontWeight.bold),
                  CustomText(
                      text:
                          "\$${(widget.product.price / 100).toStringAsFixed(2)}",
                      size: 20,
                      weight: FontWeight.w400),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                      text: "Description", size: 18, weight: FontWeight.w400),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.product.description,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: grey, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: primary,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Pepsi', '7Up', 'Cerveza', 'Agua']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 36,
                            ),
                            onPressed: () {
                              if (quantity != 1) {
                                setState(() {
                                  quantity -= 1;
                                });
                              }
                            }),
                      ),
                      GestureDetector(
                        onTap: () async {
                          app.changeLoading();
                          print("All set loading");

                          bool value = await user.addToCard(
                              product: widget.product, quantity: quantity);
                          if (value) {
                            print("Item added to cart");
                            _key.currentState.showSnackBar(
                                SnackBar(content: Text("Añadido al carrito")));
                            user.reloadUserModel();
                            app.changeLoading();
                            return;
                          } else {
                            print("Item no añadido al carrito");
                          }
                          print("lOADING SET TO FALSE");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: app.isLoading
                              ? Loading()
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(28, 12, 28, 12),
                                  child: CustomText(
                                    text: "Añade $quantity al carrito",
                                    color: white,
                                    size: 22,
                                    weight: FontWeight.w300,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 36,
                              color: red,
                            ),
                            onPressed: () {
                              setState(() {
                                quantity += 1;
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
