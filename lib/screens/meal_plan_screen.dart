import 'package:flutter/material.dart';

class MealPlanScreen extends StatefulWidget {
  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  Map<String, List<String>> mealPlan = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  final TextEditingController _mealController = TextEditingController();

  void _addMeal(String day) {
    if (_mealController.text.isNotEmpty) {
      setState(() {
        mealPlan[day]?.add(_mealController.text);
      });
      _mealController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddMealDialog(String day) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Meal to $day'),
          content: TextField(
            controller: _mealController,
            decoration: InputDecoration(hintText: 'Enter meal name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _addMeal(day),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeMeal(String day, int index) {
    setState(() {
      mealPlan[day]?.removeAt(index);
    });
  }

  void _resetMealPlan() {
    setState(() {
      mealPlan = {
        'Monday': [],
        'Tuesday': [],
        'Wednesday': [],
        'Thursday': [],
        'Friday': [],
        'Saturday': [],
        'Sunday': [],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetMealPlan,
          ),
        ],
      ),
      body: ListView(
        children: mealPlan.keys.map((day) {
          return Card(
            child: ExpansionTile(
              title: Text(day),
              children: mealPlan[day]!.asMap().entries.map((entry) {
                int index = entry.key;
                String meal = entry.value;
                return ListTile(
                  title: Text(meal),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeMeal(day, index),
                  ),
                );
              }).toList(),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showAddMealDialog(day),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
