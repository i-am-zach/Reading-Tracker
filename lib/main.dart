import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'books/main.dart';
import "list/main.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabContainer(),
    );
  }
}

class TabContainer extends StatelessWidget {
  const TabContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.calendar_today)),
                Tab(icon: Icon(Icons.book)),
              ],
            ),
          ),
          body: MultiProvider(
            providers: [
              StreamProvider<List<Book>>.value(
                initialData: [],
                value: Book.all(),
              ),
              StreamProvider<List<ReadingSession>>.value(
                initialData: [],
                value: ReadingSession.all(),
                catchError: (context, error) => [],
              ),
            ],
            child: TabBarView(
              children: <Widget>[
                ListPage(),
                Center(child: Text("Calendar")),
                BookPage(),
              ],
            ),
          ),
        ));
  }
}
