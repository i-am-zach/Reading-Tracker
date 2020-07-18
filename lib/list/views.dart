import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_tracker/list/components/widgets.dart';
import 'main.dart';
import "package:reading_tracker/books/main.dart";

class ListPage extends StatefulWidget {
  const ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startPageController = TextEditingController();
  final TextEditingController endPageController = TextEditingController();

  String bookId;
  int startPage;
  int endPage;
  bool buttonEnabled;

  @override
  initState() {
    super.initState();
    buttonEnabled = false;
    startPageController.addListener(() {
      setState(() {
        startPage = int.tryParse(startPageController.text);
        if(startPage != null && bookId != null) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
      });
    });
    endPageController.addListener(() {
      setState(() {
        endPage = int.tryParse(endPageController.text);
        if(endPage != null) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ReadingSession> sessions = Provider.of<List<ReadingSession>>(context);
    List<Book> books = Provider.of<List<Book>>(context);

    if(books.length == 1) {
      setState((){
        bookId = books.first.id;
      });
    }

    return SafeArea(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                  title: Text("Reading Sessions"),
                  expandedHeight: 100.0,
                  actions: [
                    ActionChip(
                      avatar: Icon(Icons.settings),
                      label: Text("Settings"),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              bool active = ReadingSession.isActive(sessions);
                              return Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: active
                                      ? Column(
                                          children: <Widget>[
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: endPageController,
                                              decoration: InputDecoration(
                                                labelText: "End Page",
                                              ),
                                              validator: (text) {
                                                try {
                                                  int.parse(text);
                                                } catch (err) {
                                                  return "Please enter a whole number";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            if (books.length > 1)
                                              DropdownButton(
                                                items: books
                                                    .map(
                                                      (book) =>
                                                          DropdownMenuItem(
                                                        value: book.id,
                                                        child: Text(book.title),
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (id) {
                                                  setState(() {
                                                    bookId = id;
                                                  });
                                                },
                                              ),
                                            if (books.length <= 1)
                                              TextFormField(
                                                readOnly: true,
                                                initialValue: books.isEmpty
                                                    ? "No books"
                                                    : books.first.title,
                                                decoration: InputDecoration(
                                                  labelText: "Book",
                                                ),
                                              ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: startPageController,
                                              decoration: InputDecoration(
                                                labelText: "Page",
                                              ),
                                              validator: (text) {
                                                try {
                                                  int.parse(text);
                                                } catch (err) {
                                                  return "Please enter a whole number";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            });
                      },
                      autofocus: false,
                    ),
                  ]),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index >= sessions.length) {
                    return null;
                  }
                  ReadingSession session = sessions[index];
                  return SessionCard(
                    session: session,
                  );
                }),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
              child: FloatingActionButton(
                onPressed: buttonEnabled ? (){
                  if(ReadingSession.isActive(sessions)) {
                    ReadingSession.stop(endPage: endPage);
                    setState(() {
                      buttonEnabled = startPage != null && bookId != null;
                    });
                  } else {
                    ReadingSession.start(startPage: startPage, bookId: bookId);
                    buttonEnabled = endPage != null;
                  }
                } : null,
                child: ReadingSession.isActive(sessions) ? Icon(Icons.stop, size: 36.0) : Icon(Icons.play_arrow, size: 36.0),
                backgroundColor: buttonEnabled ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
