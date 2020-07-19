import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reading_tracker/list/main.dart';
import "package:reading_tracker/books/main.dart";

class SessionCard extends StatelessWidget {
  final ReadingSession session;
  final bool isFirstOfDate;
  const SessionCard({Key key, @required this.session, this.isFirstOfDate})
      : super(key: key);

  String formattedTime(DateTime dt, BuildContext context) {
    TimeOfDay time = TimeOfDay(hour: dt.hour, minute: dt.minute);
    return time.format(context);
  }

  String formattedDate(DateTime dt) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
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
      fontSize: 18.0,
      color: Colors.grey[900],
    );

    TextStyle progressStyle = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.italic,
    );

    TextStyle unemphasizedStyle = TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.italic,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return SessionPage(session: session, books: books);
              },
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isFirstOfDate)
                    Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 4.0,
                        ),
                        color: Colors.blue[200],
                        child: Text(
                          formattedDate(session.startTime),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  SessionListTile(
                      icon: FontAwesomeIcons.book,
                      title: book != null ? book.title : "None"),
                  SessionListTile(
                    icon: FontAwesomeIcons.bookmark,
                    richText: RichText(
                      text: TextSpan(
                          text: "${session.startPage} ",
                          style: textStyle,
                          children: [
                            TextSpan(
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                text:
                                    "${(100 * session.startPage / book.pages).toStringAsFixed(2)}%"),
                          ]),
                    ),
                  ),
                  SessionListTile(
                    icon: FontAwesomeIcons.clock,
                    title: formattedTime(session.startTime, context),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: calculateLineHeight(),
              width: 4,
              child: Container(color: Colors.blue[200]),
            ),
            if (!session.isIncomplete())
              Card(
                color: Color(0xffF7FFFE),
                elevation: 4.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SessionListTile(
                      icon: FontAwesomeIcons.bookmark,
                      richText: RichText(
                        text: TextSpan(
                            text: "${session.endPage} ",
                            style: textStyle,
                            children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  text:
                                      "${(100 * session.endPage / book.pages).toStringAsFixed(2)}%"),
                            ]),
                      ),
                    ),
                    SessionListTile(
                      icon: FontAwesomeIcons.clock,
                      title: formattedTime(session.endTime, context),
                    ),
                    SessionListTile(
                      icon: FontAwesomeIcons.arrowCircleUp,
                      richText: RichText(
                        text: TextSpan(
                            text: "${session.numPages} pages ",
                            style: textStyle,
                            children: [
                              TextSpan(
                                  style: progressStyle,
                                  text:
                                      "+${(100 * session.numPages / book.pages).toStringAsFixed(2)}%"),
                            ]),
                      ),
                    ),
                    SessionListTile(
                      icon: FontAwesomeIcons.chartBar,
                      richText: RichText(
                        text: TextSpan(
                            text:
                                "${session.minutesPerPage.toStringAsFixed(2)} ",
                            style: textStyle,
                            children: [
                              TextSpan(
                                text: "min / page",
                                style: unemphasizedStyle,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SessionListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final RichText richText;
  const SessionListTile({Key key, this.icon, this.title, this.richText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Container(
        child: Icon(icon, size: 20.0),
      ),
      title: Container(
        child: richText != null
            ? richText
            : Text(title,
                style: TextStyle(
                  fontSize: 18.0,
                )),
      ),
    );
  }
}
