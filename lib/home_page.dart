import 'package:flutter/material.dart';
import 'package:garlic_price/list_all_post_page.dart';
import 'package:garlic_price/price_page.dart';
//import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screen = [
      PricePage(),
      ListAllPostPage(),
      Center(
        child: Text(
          'Spaces',
          style: TextStyle(fontSize: 70),
        ),
      ),
      Center(
        child: Text(
          'Meet',
          style: TextStyle(fontSize: 71),
        ),
      ),
    ];
    return Scaffold(
      // extendBodyBehindAppBar: true,

      body: screen[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 16,
              //fontWeight: FontWeight.bold,
              //fontFamily:
            ),
          ),
        ),
        child: NavigationBar(
          height: 80,
          // backgroundColor: const Color(0xFFf1f5fb),
          backgroundColor: Colors.blue,
          //selected

          //use to show/hide Icon name
          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //use to slow animation
          animationDuration: const Duration(seconds: 1),
          selectedIndex: index,
          //-----------use for get select bar from user
          onDestinationSelected: (index) => setState(() => this.index = index),
          // ----------
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.attach_money_outlined),
              selectedIcon: Icon(Icons.attach_money),
              label: ('ราคา'),
            ),
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              selectedIcon: Icon(Icons.group),
              label: ('ประกาศ'),
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: ('แชท'),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: ('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
