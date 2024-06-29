import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'meal_plan_screen.dart';
import 'grocery_list_screen.dart';
import 'user_profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? username;

  List<Widget> _widgetOptions() {
    return [
      SearchScreen(),
      MealPlanScreen(),
      GroceryListScreen(),
      username != null
          ? UserProfileScreen(username: username!)
          : Center(child: Text('Please log in')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _login() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        username = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recipe and Meal Planning App'),
            if (username != null)
              Text('Hello, $username!'),
            if (username == null)
              GestureDetector(
                onTap: _login,
                child: Row(
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 5),
                    Text('Login'),
                  ],
                ),
              ),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
