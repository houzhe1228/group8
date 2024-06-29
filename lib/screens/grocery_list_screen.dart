import 'package:flutter/material.dart';

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<Map<String, dynamic>> _groceryList = [];
  final TextEditingController _itemController = TextEditingController();

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      setState(() {
        _groceryList.add({
          'name': _itemController.text,
          'completed': false,
        });
      });
      _itemController.clear();
    }
  }

  void _toggleItemCompletion(int index) {
    setState(() {
      _groceryList[index]['completed'] = !_groceryList[index]['completed'];
    });
  }

  void _removeItem(int index) {
    setState(() {
      _groceryList.removeAt(index);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                hintText: 'Enter grocery item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _groceryList.length,
                itemBuilder: (context, index) {
                  final item = _groceryList[index];
                  return ListTile(
                    title: Text(
                      item['name'],
                      style: TextStyle(
                        decoration: item['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: item['completed'],
                      onChanged: (value) {
                        _toggleItemCompletion(index);
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
