import 'dart:convert';
import 'dart:io';

import 'package:flutter_application/globals.dart' as globals;
import 'package:flutter_application/models/category.dart';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService();

  Future<List<Category>> fetchCategories() async {
    http.Response response =
        await http.get(Uri.parse(globals.baseUrl + '/categories'));

    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future<Category> updateCategory(Category category) async {
    String uri = globals.baseUrl + '/categories/' + category.id.toString();

    http.Response response = await http.put(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode(
        {
          'name': category.name,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Error happened on update');
    }

    return Category.fromJson(jsonDecode(response.body));
  }
}
