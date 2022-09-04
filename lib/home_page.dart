import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      Center(
        child:
            Text('HomePage', style: Theme.of(context).textTheme.headlineMedium),
      ),
      Center(
        child: Text(
          'Chat',
          style: TextStyle(fontSize: 70),
        ),
      ),
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
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          Icons.home_outlined,
          color: Colors.blue,
        ),
        title: Text(
          'ราคากระเทียมจีน',
          //style: TextStyle(color: Colors.blue),
          style: GoogleFonts.notoSansThai(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: screen[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade300,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          height: 80,
          backgroundColor: const Color(0xFFA6F415),

          //use to show/hide Icon name
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //use to slow animation
          animationDuration: const Duration(seconds: 1),
          selectedIndex: index,
          //-----------use for get select bar from user
          onDestinationSelected: (index) => setState(() => this.index = index),
          // ----------
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: ('หน้าแรก'),
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: ('Chat'),
            ),
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              selectedIcon: Icon(Icons.group),
              label: ('Spaces'),
            ),
            NavigationDestination(
              icon: Icon(Icons.videocam_outlined, size: 50),
              selectedIcon: Icon(Icons.videocam, size: 50),
              label: ('Meet'),
            ),
          ],
        ),
      ),
    );
  }
}
