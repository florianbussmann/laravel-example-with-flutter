import 'package:flutter/material.dart';
import 'package:flutter_application/providers/AuthProvider.dart';
import 'package:flutter_application/screens/categories.dart';
import 'package:flutter_application/screens/transactions.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> widgetOptions = [Transactions(), Categories()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Flutter",
      home: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout), label: 'Log out'),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<void> onItemTapped(int index) async {
    if (index == 2) {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}
