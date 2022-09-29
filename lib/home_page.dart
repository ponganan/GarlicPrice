import 'package:flutter/material.dart';
import 'package:garlic_price/check_user_login_page.dart';
import 'package:garlic_price/list_all_post_page.dart';
import 'package:garlic_price/list_price.dart';
import 'package:garlic_price/price_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final screen = [
    ListPrice(),
    PriceChart(),
    ListAllPostPage(),
    CheckUserLoginPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index],
      // warp widget with NavigationBarTheme
      bottomNavigationBar: NavigationBarTheme(
        //have to set data:
        data: NavigationBarThemeData(
          //set theme colors
          indicatorColor: Colors.blue.shade100,

          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: const Color(0xFFf1f5fb),
          selectedIndex: index,
          //use labelBehavior for hidden or unhidden text
          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(seconds: 1),
          onDestinationSelected: (index) => setState(
            () => this.index = index,
          ),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'หน้าแรก',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_graph_outlined),
              selectedIcon: Icon(
                Icons.auto_graph,
              ),
              label: 'กราฟ',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'ประกาศ',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: 'บัญชี',
            ),
          ],
        ),
      ),
    );
  }
}
