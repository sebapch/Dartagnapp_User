import 'package:flutter/material.dart';
import 'package:food_course/scr/helpers/order.dart';
import 'package:food_course/scr/helpers/style.dart';
import 'package:food_course/scr/models/cart_item.dart';
import 'package:food_course/scr/models/products.dart';
import 'package:food_course/scr/providers/app.dart';
import 'package:food_course/scr/providers/product.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/widgets/custom_text.dart';
import 'package:food_course/scr/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

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
        title: CustomText(text: "Mi pedido: "),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: app.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: user.userModel.cart.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            user.userModel.cart[index].image,
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: user.userModel.cart[index].name +
                                          "\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          "\$${(user.userModel.cart[index].price / 100).toStringAsFixed(2)} \n\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300)),
                                  TextSpan(
                                      text: "Cantidad: ",
                                      style: TextStyle(
                                          color: grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: user.userModel.cart[index].quantity
                                          .toString(),
                                      style: TextStyle(
                                          color: primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ]),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: red,
                                  ),
                                  onPressed: () async {
                                    app.changeLoading();
                                    bool value = await user.removeFromCart(
                                        cartItem: user.userModel.cart[index]);
                                    if (value) {
                                      user.reloadUserModel();
                                      print("Item añadido al carrito");
                                      _key.currentState.showSnackBar(SnackBar(
                                          content: Text("Item eliminado")));
                                      app.changeLoading();
                                      return;
                                    } else {
                                      print("ITEM WAS NOT REMOVED");
                                      app.changeLoading();
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text:
                          " \$${(user.userModel.totalCartPrice / 100).toStringAsFixed(2)}",
                      style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: primary),
                child: FlatButton(
                    onPressed: () {
                      if (user.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Esta Vacia',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Vas a pagar \$${(user.userModel.totalCartPrice / 100).toStringAsFixed(2)} por tu pedido',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            var uuid = Uuid();
                                            String id = uuid.v4();
                                            _orderServices.createOrder(
                                                userId: user.user.uid,
                                                id: id,
                                                description:
                                                    "DESCRIPCION del producto",
                                                status: "En preparación",
                                                totalPrice: user
                                                    .userModel.totalCartPrice,
                                                cart: user.userModel.cart);
                                            for (CartItemModel cartItem
                                                in user.userModel.cart) {
                                              bool value =
                                                  await user.removeFromCart(
                                                      cartItem: cartItem);
                                              if (value) {
                                                user.reloadUserModel();
                                                print("Añadido al carrito");
                                                _key.currentState.showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Orden creada")));
                                              } else {
                                                print("ITEM WAS NOT REMOVED");
                                              }
                                            }
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text("Orden creada")));
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Aceptar",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: primary,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Pagar",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
