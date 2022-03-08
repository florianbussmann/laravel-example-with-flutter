import 'package:flutter/material.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/services/api.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  late ApiService apiService;

  CategoryProvider() {
    apiService = ApiService();

    init();
  }

  Future init() async {
    categories = await apiService.fetchCategories();
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
