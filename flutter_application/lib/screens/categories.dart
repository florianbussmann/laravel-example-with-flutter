import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application/globals.dart' as globals;

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  late Future<List<Category>> futureCategories;

  Future<List<Category>> fetchCategories() async {
    http.Response response =
        await http.get(Uri.parse(globals.baseUrl + '/categories'));

    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Category category = snapshot.data![index];
                  return ListTile(title: Text(category.name));
                });
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Something went wrong");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
