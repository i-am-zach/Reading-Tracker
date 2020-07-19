import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_tracker/list/components/widgets.dart';
import 'main.dart';
import "package:reading_tracker/books/main.dart";

bool isFirstOfDate({ReadingSession session, List<ReadingSession> sessions}) {
  ReadingSession min;
  sessions.forEach((ses) {
    if (session.startTime.day == ses.startTime.day &&
        session.startTime.month == ses.startTime.month &&
        session.startTime.year == ses.startTime.year) {
      if (min == null) {
        min = ses;
      } else if (ses.startTime.compareTo(min.startTime) < 0) {
        min = ses;
      }
    }
  });
  return min.startTime == session.startTime;
}

class ListPage extends StatefulWidget {
  const ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    List<ReadingSession> sessions = Provider.of<List<ReadingSession>>(context);
    bool isActive = ReadingSession.isActive(sessions: sessions);

    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text("Reading Sessions"),
              expandedHeight: 150.0,
              pinned: true,
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (index >= sessions.length) {
                  return null;
                }
                ReadingSession session = sessions[index];
                return SessionCard(
                  session: session,
                  isFirstOfDate:
                      isFirstOfDate(session: session, sessions: sessions),
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
              onPressed: () {
                if (isActive) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController ctr = TextEditingController(
                            text: sessions.last.startPage != null
                                ? sessions.last.startPage.toString()
                                : "0");
                        DateTime now = DateTime.now();
                        Duration diff = now.difference(sessions.last.startTime);
                        return Container(
                          child: CupertinoAlertDialog(
                            title: Text(diff.toString()),
                            content: CupertinoTextField(
                              controller: ctr,
                              keyboardType: TextInputType.number,
                              placeholder: "End Page",
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text("Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text("Finish"),
                                onPressed: () {
                                  if (int.tryParse(ctr.text) != null) {
                                    ReadingSession.stop(
                                        endPage: int.tryParse(ctr.text));
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  ReadingSession.start();
                }
              },
              child: isActive
                  ? Icon(Icons.stop, size: 36.0)
                  : Icon(Icons.play_arrow, size: 36.0),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class SessionPage extends StatefulWidget {
  final List<Book> books;
  final ReadingSession session;
  SessionPage({Key key, @required this.session, @required this.books})
      : super(key: key);

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  TextEditingController startPageCtr;
  TextEditingController endPageCtr;
  String bookId;
  DateTime startTime;
  DateTime endTime;
  bool deleted;

  @override
  dispose() {
    super.dispose();
    if (!deleted) {
      ReadingSession newSession = ReadingSession(
        id: widget.session.id,
        bookId: bookId,
        startPage: int.tryParse(startPageCtr.text),
        endPage: int.tryParse(endPageCtr.text),
        startTime: startTime,
        endTime: endTime,
      );
      ReadingSession.insert(newSession);
    }
  }

  @override
  void initState() {
    super.initState();
    // Book ID
    if (widget.session.bookId != null) {
      bookId = widget.session.bookId;
    } else if (widget.books.isNotEmpty) {
      bookId = widget.books.first.id;
    }
    // Times
    startTime = widget.session.startTime;
    endTime = widget.session.endTime;

    // Text Controllers
    if (widget.session.startPage != null) {
      startPageCtr =
          TextEditingController(text: widget.session.startPage.toString());
    } else {
      startPageCtr = TextEditingController();
    }
    if (widget.session.endPage != null) {
      endPageCtr =
          TextEditingController(text: widget.session.endPage.toString());
    } else {
      endPageCtr = TextEditingController();
    }
    // Deleted
    deleted = false;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle heading = TextStyle(
      fontSize: 24.0,
    );
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  ////////////////
                  // Pages Section
                  ////////////////
                  Text(
                    "Pages",
                    style: heading,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: startPageCtr,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text("To"),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: endPageCtr,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 30.0,
                  ),
                  ////////////////
                  // Book Section
                  ///////////////
                  Text("Book", style: heading),
                  if (widget.books.length > 1)
                    DropdownButton(
                      value: bookId,
                      onChanged: (id) {
                        setState(() {
                          bookId = id;
                        });
                      },
                      items: widget.books
                          .map(
                            (book) => DropdownMenuItem(
                              child: Text(book.title),
                              value: book.id,
                            ),
                          )
                          .toList(),
                    ),
                  if (widget.books.length == 1)
                    TextFormField(
                      initialValue: widget.books.last.title,
                      readOnly: true,
                    ),
                  if (widget.books.isEmpty)
                    TextFormField(
                      initialValue: "None",
                      readOnly: true,
                    ),
                  Divider(
                    height: 30.0,
                  ),
                  /////////////////////
                  // Start Time Section
                  /////////////////////
                  Text("Start Time", style: heading),
                  SizedBox(
                    height: 8.0,
                  ),
                  CupertinoButton(
                    color: Colors.amber,
                    child: Text(
                      startTime.toString(),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: Text("Choose a Start Time"),
                          message: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CupertinoDatePicker(
                              initialDateTime: startTime,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  startTime = newTime;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 30.0,
                  ),
                  ////////////////////
                  /// End Time Section
                  ////////////////////
                  Text("End Time", style: heading),
                  SizedBox(
                    height: 8.0,
                  ),
                  CupertinoButton(
                    color: Colors.amber,
                    child: Text(
                      endTime != null ? endTime.toString() : "None",
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: Text("Choose a End Time"),
                          message: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CupertinoDatePicker(
                              initialDateTime: endTime,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  endTime = newTime;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  CupertinoButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text("Warning"),
                          content: Text(
                              "Are you sure you want to delete this session?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text("No",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  )),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text("Yes",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                setState(() {
                                  deleted = true;
                                });
                                ReadingSession.delete(widget.session.id);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
