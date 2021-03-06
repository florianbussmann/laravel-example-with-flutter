import 'dart:convert';
import 'dart:io';

import 'package:flutter_application/globals.dart' as globals;
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/models/transaction.dart';

import 'package:http/http.dart' as http;

class ApiService {
  late String _token;

  ApiService(String token) {
    _token = token;
  }

  Future<List<Category>> fetchCategories() async {
    http.Response response =
        await http.get(Uri.parse(globals.baseUrl + '/categories'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future<Category> addCategory(String name) async {
    String uri = globals.baseUrl + '/categories';

    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
      body: jsonEncode(
        {
          'name': name,
        },
      ),
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception('Error happened on create');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<Category> updateCategory(Category category) async {
    String uri = globals.baseUrl + '/categories/' + category.id.toString();

    http.Response response = await http.put(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
      body: jsonEncode(
        {
          'name': category.name,
        },
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error happened on update');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteCategory(int id) async {
    String uri = globals.baseUrl + '/categories/' + id.toString();

    http.Response response = await http.delete(
      Uri.parse(uri),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw Exception('Error happened on delete');
    }
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirm, String deviceName) async {
    String uri = globals.baseUrl + '/auth/register';

    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode(
        {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirm,
          'device_name': deviceName,
        },
      ),
    );

    if (response.statusCode == HttpStatus.unprocessableEntity) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        for (var element in value) {
          errorMessage += element + '\n';
        }
      });
      throw Exception(errorMessage);
    }

    return response.body;
  }

  Future<String> login(String email, String password, String deviceName) async {
    String uri = globals.baseUrl + '/auth/login';

    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      ),
    );

    if (response.statusCode == HttpStatus.unprocessableEntity) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        for (var element in value) {
          errorMessage += element + '\n';
        }
      });
      throw Exception(errorMessage);
    }

    return response.body;
  }

  Future<List<Transaction>> fetchTransactions() async {
    http.Response response =
        await http.get(Uri.parse(globals.baseUrl + '/transactions'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    List transactions = jsonDecode(response.body);

    return transactions
        .map((category) => Transaction.fromJson(category))
        .toList();
  }

  Future<Transaction> addTransaction(String amount, String categoryId,
      String description, String transactionDate) async {
    String uri = globals.baseUrl + '/transactions';

    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
      body: jsonEncode(
        {
          'amount': amount,
          'category_id': int.parse(categoryId),
          'description': description,
          'transaction_date': transactionDate,
        },
      ),
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception('Error happened on create');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    String uri = globals.baseUrl + '/transactions/' + transaction.id.toString();

    http.Response response = await http.put(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
      body: jsonEncode(
        {
          'amount': transaction.amount,
          'category_id': transaction.categoryId,
          'description': transaction.description,
          'transaction_date': transaction.transactionDate,
        },
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error happened on update');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteTransaction(int id) async {
    String uri = globals.baseUrl + '/transactions/' + id.toString();

    http.Response response = await http.delete(
      Uri.parse(uri),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw Exception('Error happened on delete');
    }
  }
}
