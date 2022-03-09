import 'package:flutter/material.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/providers/AuthProvider.dart';
import 'package:flutter_application/services/api.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  late AuthProvider _authProvider;
  late ApiService apiService;

  CategoryProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
    apiService = ApiService(_authProvider.token);

    init();
  }

  Future init() async {
    categories = await apiService.fetchCategories();
    notifyListeners();
  }

  Future addCategory(String name) async {
    Category addedCategory = await apiService.addCategory(name);
    categories.add(addedCategory);

    notifyListeners();
  }

  Future updateCategory(Category category) async {
    Category updatedCategory = await apiService.updateCategory(category);
    int index = categories.indexOf(category);
    categories[index] = updatedCategory;

    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await apiService.deleteCategory(category.id);
    categories.remove(category);

    notifyListeners();
  }
}
