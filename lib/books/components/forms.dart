import 'package:flutter/material.dart';
import "../main.dart";

class EditBookForm extends StatefulWidget {
  final Book book;
  const EditBookForm({
    Key key,
    @required this.book,
  }) : super(key: key);

  @override
  _EditBookFormState createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController;
  TextEditingController authorController;
  TextEditingController pagesController;

  @override void initState() {
    super.initState();
    titleController = new TextEditingController(text: widget.book.title);
    authorController = new TextEditingController(text: widget.book.author);
    pagesController = new TextEditingController(text: widget.book.pages.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Book"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("id: ${widget.book.id}"),
            TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                }),
            TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Author",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                }),
            TextFormField(
                controller: pagesController,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: InputDecoration(
                  labelText: "Pages",
                ),
                validator: (value) {
                  RegExp _numeric = RegExp(r'^-?[0-9]+$');
                  if (value.isEmpty) {
                    return "Please enter a number";
                  } else if (!_numeric.hasMatch(value)) {
                    return "Not a whole number";
                  }
                  return null;
                }),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Edit"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              String title = titleController.text;
              String author = authorController.text;
              int pages = int.parse(pagesController.text);
              Book book = Book(title: title, author: author, pages: pages, id: widget.book.id);
              Book.insert(book);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class AddBookForm extends StatefulWidget {
  const AddBookForm({
    Key key,
  }) : super(key: key);

  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  String id;

  @override
  initState() {
    super.initState();
    id = "";
  }

  void updateId() {
    setState(() {
      id = Book.generateID(titleController.text, authorController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    titleController.addListener(updateId);
    authorController.addListener(updateId);
    return AlertDialog(
      title: Text("Add Book"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("id: $id"),
            TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                }),
            TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Author",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                }),
            TextFormField(
                controller: pagesController,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: InputDecoration(
                  labelText: "Pages",
                ),
                validator: (value) {
                  RegExp _numeric = RegExp(r'^-?[0-9]+$');
                  if (value.isEmpty) {
                    return "Please enter a number";
                  } else if (!_numeric.hasMatch(value)) {
                    return "Not a whole number";
                  }
                  return null;
                }),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Add"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              String title = titleController.text;
              String author = authorController.text;
              int pages = int.parse(pagesController.text);
              String id = Book.generateID(title, author);
              Book book =
                  Book(author: author, title: title, pages: pages, id: id);
              Book.insert(book);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
