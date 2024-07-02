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
  int? userId;
  String? username;

  @override
  void initState() {
    super.initState();
    // 这里假设您有某种方式来加载用户的登录信息
    // 假设的加载代码:
    // userId = SomeAuthService.getCurrentUserId();
    // username = SomeAuthService.getCurrentUsername();
    // For demonstration purposes, we will use hardcoded values.
    userId = 1; // This should be replaced with actual user id retrieval logic.
    username = 'Test User'; // This should be replaced with actual username retrieval logic.

    // 调试输出
    print('Username: $username, UserId: $userId');
  }

  List<Widget> _widgetOptions() {
  return [
    SearchScreen(),
    MealPlanScreen(),
    if (userId != null)
      GroceryListScreen(userId: userId!)
    else
      Center(child: Text('Please log in')), // 添加此部分来处理 userId 为 null 的情况
    if (username != null && userId != null)
      UserProfileScreen(userId: userId!, username: username!)
    else
      Center(child: Text('Please log in')),
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
        // 假设这里有逻辑可以获取userId
        userId = 1; // Replace with actual logic to get the userId
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
