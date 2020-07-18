import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> books = Provider.of<List<Book>>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Books"),
            expandedHeight: 200.0,
            floating: true,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_circle),
                tooltip: 'Add new entry',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddBookForm(),
                    barrierDismissible: true,
                  );
                },
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index >= books.length) {
                  return null;
                }
                Book book = books[index];
                return BookCard(book: book);
              },
            ),
          ),
        ],
      ),
    );
  }
}
