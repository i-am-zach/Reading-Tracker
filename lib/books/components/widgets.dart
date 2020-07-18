import 'package:flutter/material.dart';
import '../main.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    Key key,
    @required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Container(
                child: Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 6.0),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.start,
                buttonPadding: EdgeInsets.all(0.0),
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.amber[600],
                      ),
                    ),
                    splashColor: Colors.amber[100],
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditBookForm(
                          book: book,
                        ),
                        barrierDismissible: true,
                      );
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    splashColor: Colors.red[100],
                    onPressed: () {
                      Book.delete(book.id);
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Deleted ${book.title}")));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: 5.0, right: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${book.pages}",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[200],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
