import 'package:flutter/material.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/providers/CategoryProvider.dart';
import 'package:provider/provider.dart';

Widget buildCategoriesDropdown(
    caller, TextEditingController categoryController) {
  return Consumer<CategoryProvider>(
    builder: (context, categoryProvider, child) {
      List<Category> categories = categoryProvider.categories;

      return DropdownButtonFormField(
        items: categories.map<DropdownMenuItem<String>>((element) {
          return DropdownMenuItem(
            value: element.id.toString(),
            child: Text(
              element.name,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          );
        }).toList(),
        value: categoryController.text.isEmpty ? null : categoryController.text,
        onChanged: (String? newValue) {
          if (newValue == null) {
            return;
          }

          caller.setState(() {
            categoryController.text = newValue.toString();
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Category',
        ),
        dropdownColor: Colors.white,
        validator: (value) {
          if (value == null) {
            return 'Please select category';
          }
        },
      );
    },
  );
}
