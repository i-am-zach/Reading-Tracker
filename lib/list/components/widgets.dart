import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:reading_tracker/list/main.dart';
import "package:reading_tracker/books/main.dart";

class SessionCard extends StatelessWidget {
  final double iconSize = 24.0;
  final double elemSpacing = 8.0;

  final ReadingSession session;
  const SessionCard({Key key, @required this.session}) : super(key: key);

  String formattedTime(DateTime dt) {
    return "${dt.hour}:${dt.minute}";
  }

  String formattedDate(DateTime dt) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${months[dt.month - 1]}. ${dt.day}, ${dt.year}";
  }

  double calculateLineHeight() {
    if (session.isIncomplete()) {
      return 35;
    }
    Duration duration = session.duration;
    double output = duration.inMinutes * 1.0;
    if (output > 60 * 4) {
      return 60 * 4.0;
    }
    return duration.inMinutes * 1.0;
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = Provider.of<List<Book>>(context);
    Book book;
    books.forEach((b) {
      if (b.id == session.bookId) {
        book = b;
      }
    });

    TextStyle textStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.grey[900],
    );
    TextStyle unemphasizedStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.grey[400],
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.book, size: iconSize),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Container(
                        child: Text(
                          book != null ? book.title : "None",
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: elemSpacing),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.calendar_today, size: iconSize),
                      ),
                      SizedBox(width: 6.0),
                      Container(
                        child: Text(
                          formattedDate(session.startTime),
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: elemSpacing),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.bookmark_border, size: iconSize),
                      ),
                      SizedBox(width: 6.0),
                      Container(
                        child: RichText(
                            text: TextSpan(
                          text: "${session.startPage}",
                          style: textStyle,
                          children: <TextSpan>[
                            TextSpan(text: " / 551", style: unemphasizedStyle),
                          ],
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: elemSpacing),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.timer, size: iconSize),
                      ),
                      SizedBox(width: 6.0),
                      Container(
                        child: Text(
                          formattedTime(session.startTime),
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: calculateLineHeight(),
            width: 4,
            child: Container(color: Colors.amber),
          ),
          if (!session.isIncomplete())
            Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.bookmark_border, size: iconSize),
                        ),
                        SizedBox(width: 6.0),
                        Container(
                          child: RichText(
                              text: TextSpan(
                            text: "${session.endPage}",
                            style: textStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text: " / 551", style: unemphasizedStyle),
                            ],
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: elemSpacing),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.timer, size: iconSize),
                        ),
                        SizedBox(width: 6.0),
                        Container(
                          child: Text(
                            formattedTime(session.endTime),
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
