import 'package:flutter/material.dart';
import '../database_helper.dart';

class GroceryListScreen extends StatefulWidget {
  final int userId;

  GroceryListScreen({required this.userId});

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<Map<String, dynamic>> _groceryList = [];
  final TextEditingController _itemController = TextEditingController();

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      Map<String, dynamic> newItem = {
        'name': _itemController.text,
        'completed': 0, // 在数据库中使用整数表示布尔值
        'userID': widget.userId // 使用传递的用户 ID
      };
      DatabaseHelper.instance.addGroceryItem(newItem).then((id) {
        setState(() {
          newItem['id'] = id; // 将数据库生成的id添加到item中
          _groceryList.add(newItem);
        });
        _itemController.clear();
      });
    }
  }

  void _toggleItemCompletion(int index) {
    setState(() {
      _groceryList[index]['completed'] = !_groceryList[index]['completed'];
    });
  }

  void _removeItem(int index) {
    int groceryId = _groceryList[index]['id'];
    DatabaseHelper.instance.deleteGroceryItem(groceryId).then((_) {
      setState(() {
        _groceryList.removeAt(index);
      });
    });
  }

  void _resetList() {
    setState(() {
      _groceryList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetList,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (context, index) {
          final item = _groceryList[index];
          return ListTile(
            title: Text(item['name']),
            trailing: IconButton(
              icon: Icon(
                item['completed'] == 1 ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              onPressed: () => _toggleItemCompletion(index),
            ),
            onLongPress: () => _removeItem(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            controller: _itemController,
            decoration: InputDecoration(hintText: 'Enter item name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
