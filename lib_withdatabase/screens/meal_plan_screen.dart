import 'package:flutter/material.dart';
import '../database_helper.dart';

class MealPlanScreen extends StatefulWidget {
  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  Map<String, List<Map<String, dynamic>>> mealPlan = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  final TextEditingController _mealController = TextEditingController();
  int currentUserID = 1; // 示例代码，请根据实际情况获取当前用户的ID

  void _addMeal(String day) {
    if (_mealController.text.isNotEmpty) {
      final mealPlanData = {
        'date': day,
        'meal_name': _mealController.text,
        'user_id': currentUserID // 确保已有方式获取当前用户ID
      };

      DatabaseHelper.instance.addMealPlan(mealPlanData).then((id) {
        setState(() {
          mealPlan[day]?.add({
            'id': id.toString(),
            'meal_name': _mealController.text,
          });
          _mealController.clear();
          Navigator.pop(context);
        });
      }).catchError((error) {
        print("Error adding meal: $error");
      });
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
    int mealId = int.parse(mealPlan[day]![index]['id']);
    DatabaseHelper.instance.deleteMealPlan(mealId).then((_) {
      setState(() {
        mealPlan[day]?.removeAt(index);
      });
    }).catchError((error) {
      print("Error removing meal: $error");
    });
  }

  void _resetMealPlan() {
    DatabaseHelper.instance.resetMealPlans().then((_) {
      setState(() {
        mealPlan.keys.forEach((day) {
          mealPlan[day] = [];
        });
      });
    }).catchError((error) {
      print("Error resetting meal plans: $error");
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
                String meal = entry.value['meal_name'];
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
