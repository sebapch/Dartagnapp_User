import 'package:flutter/material.dart';
import 'package:food_course/scr/providers/app.dart';
import 'package:food_course/scr/providers/category.dart';
import 'package:food_course/scr/providers/product.dart';
import 'package:food_course/scr/providers/restaurant.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/screens/home.dart';
import 'package:food_course/scr/screens/login.dart';
import 'package:food_course/scr/screens/splash.dart';
import 'package:food_course/scr/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:food_course/scr/helpers/style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
        ChangeNotifierProvider.value(value: RestaurantProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dartagnapp',
          theme: ThemeData(
            primarySwatch: primary,
          ),
          home: ScreensController())));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:

      case Status.Unauthenticated:
      case Status.Authenticating:
        return new SplashScreen(
            seconds: 4,
            navigateAfterSeconds: LoginScreen(),
            title: new Text(
              'Bienvenido a tu cena',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: Image.asset(
              "images/dartacover.jpg",
              width: 220,
              height: 120,
            ),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            onClick: () => print("Flutter Egypt"),
            loaderColor: primary);
      case Status.Authenticated:
        return new SplashScreen(
            seconds: 4,
            navigateAfterSeconds: Home(),
            title: new Text(
              'Bienvenido a tu cena',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: new Image.asset(
              "images/dartacover.jpg",
              width: 220,
              height: 120,
            ),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            onClick: () => print("Flutter Egypt"),
            loaderColor: primary);
      default:
        return new SplashScreen(
            seconds: 4,
            navigateAfterSeconds: LoginScreen(),
            title: new Text(
              'Bienvenido a tu cena',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: new Image.asset(
              "images/dartacover.jpg",
              width: 220,
              height: 120,
            ),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            onClick: () => print("Flutter Egypt"),
            loaderColor: primary);
    }
  }
}
