import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/recipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        instructions TEXT,
        ingredients TEXT
      );
    ''');
  
    await db.execute('''
      CREATE TABLE meal_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        meal_name TEXT NOT NULL,
        recipeId INTEGER,
        userID INTEGER,
        FOREIGN KEY (recipeId) REFERENCES recipes(id),
        FOREIGN KEY (userID) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE grocery_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT NOT NULL,
        quantity INTEGER,
        userID INTEGER,
        isPurchased INTEGER DEFAULT 0,
        FOREIGN KEY (userID) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT,
        phone TEXT
      );
    ''');
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    await db.insert('users', {
      'username': 'testuser',
      'password': 'password123',
      'email': 'testuser@example.com',
      'phone': '1234567890'
    });
    await db.insert('recipes', {
      'title': 'Pancakes',
      'instructions': 'Mix ingredients and cook on a griddle.',
      'ingredients': 'Flour, Eggs, Milk, Sugar'
    });
    
    await db.insert('meal_plans', {
      'date': 'Monday',
      'meal_name': 'Breakfast',
      'recipeId': 1,
      'userID': 1
    });

    await db.insert('grocery_lists', {
      'itemName': 'Flour',
      'quantity': 2,
      'userID': 1,
      'isPurchased': 0
    });
  }
 
  Future<int> addRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  // 获取所有食谱
  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return maps.map((map) => Recipe.fromJson(map)).toList();
  }

  // 更新食谱
  Future<int> updateRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    return db.update(
      'recipes',
      recipe,
      where: 'id = ?',
      whereArgs: [recipe['id']],
    );
  }

  // 删除食谱
  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 搜索食谱
  Future<List<Map<String, dynamic>>> searchRecipes(String keyword) async {
    final db = await database;
    return db.query(
      'recipes',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );
  }

  Future<int> addMealPlan(Map<String, dynamic> mealPlan) async {
    final db = await database;
    return await db.insert('meal_plans', mealPlan);
  }

  Future<int> addGroceryItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('grocery_lists', item);
  }

  Future<int> deleteGroceryItem(int id) async {
    final db = await database;
    return await db.delete(
      'grocery_lists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleGroceryItemCompletion(int id, int completed) async {
    final db = await database;
    return await db.update(
      'grocery_lists',
      {'completed': completed},
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<void> resetGroceryList() async {
    final db = await database;
    await db.delete('grocery_lists'); // 不带任何条件，删除所有条目
  }

  // 更新膳食计划条目
  Future<int> updateMealPlan(int id, Map<String, dynamic> mealPlan) async {
    final db = await database;
    return await db.update(
      'meal_plans',
      mealPlan,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  // 删除膳食计划条目
  Future<int> deleteMealPlan(int id) async {
    final db = await database;
    return await db.delete('meal_plans', where: 'id = ?', whereArgs: [id]);
  }
  
  Future<void> resetMealPlans() async {
    final db = await database;
    await db.delete('meal_plans'); 
  }

  Future<int> addUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    throw Exception('User not found!');
  }



  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
