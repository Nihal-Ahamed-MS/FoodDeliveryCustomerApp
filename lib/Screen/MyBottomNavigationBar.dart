import 'package:flutter/material.dart';
import 'Cart.dart';
import 'Offers.dart';
import 'HomePage.dart';
import 'User.dart';


class MyBottomNavigationBar extends StatefulWidget {
  @override
   _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}
class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
 int selectedItemIndex = 0;
  final screens = [
    HomePage(),
    OffersPage(),
    CartPage(),
    UserPage(),
  ];
   Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: <Widget>[
          buildBottomNavigator(Icons.home,0),
          buildBottomNavigator(Icons.local_offer,1),
          buildBottomNavigator(Icons.shopping_cart,2),
          buildBottomNavigator(Icons.person,3),
        ],
      ),
       body: screens[selectedItemIndex]
    );
  }

   Widget buildBottomNavigator(IconData icon,int index) {
     return GestureDetector(
       onTap: (){
         setState(() {
           selectedItemIndex = index;
         });
       },
            child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width/4,
            decoration: index == selectedItemIndex ? BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4, color: Colors.blue)
              ),
              gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.3),Colors.blue.withOpacity(0.015)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter
              ),
              color: index == selectedItemIndex ? Colors.blue : Colors.white
            ) : BoxDecoration(),
            child: Icon(icon, color: index == selectedItemIndex ? Colors.blue : Colors.grey,),
          ),
     );
   }

} 