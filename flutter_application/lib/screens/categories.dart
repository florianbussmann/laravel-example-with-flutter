import 'package:flutter/material.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/providers/CategoryProvider.dart';
import 'package:flutter_application/widgets/CategoryAdd.dart';
import 'package:flutter_application/widgets/CategoryEdit.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    List<Category> categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          Category category = categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return CategoryEdit(category, provider.updateCategory);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              provider
                                  .deleteCategory(category)
                                  .then(
                                      (category) => Navigator.of(context).pop())
                                  .catchError((exception) {
                                print(exception);
                              });
                            },
                            child: Text('Confirm'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return CategoryAdd(provider.addCategory);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
