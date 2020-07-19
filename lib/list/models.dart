import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_tracker/list/main.dart';

final Firestore _db = Firestore.instance;

class ReadingSession {
  final DateTime startTime;
  final DateTime endTime;
  final int startPage;
  final int endPage;
  final String id;
  final String bookId;

  ReadingSession(
      {this.id,
      @required this.bookId,
      @required this.startTime,
      this.endTime,
      @required this.startPage,
      this.endPage});

  factory ReadingSession.fromMap(Map<String, dynamic> data) {
    DateTime startTime =
        data["startTime"] != null ? data["startTime"].toDate() : null;
    DateTime endTime =
        data["endTime"] != null ? data["endTime"].toDate() : null;
    return ReadingSession(
      bookId: data["bookId"],
      id: data["id"],
      startTime: startTime,
      endTime: endTime,
      startPage: data["startPage"],
      endPage: data["endPage"],
    );
  }

  @override
  String toString() {
    return "ReadingSession{startPage: $startPage, endPage: $endPage, duration: $duration}";
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "bookId": bookId,
        "startTime": startTime,
        "endTime": endTime,
        "startPage": startPage,
        "endPage": endPage,
      };

  int get numPages => isIncomplete() ? 0 : endPage - startPage;

  Duration get duration =>
      isIncomplete() ? null : endTime.difference(startTime);

  bool isIncomplete() => this.endPage == null || this.endTime == null;

  bool isComplete() => !this.isIncomplete();

  static Stream<List<ReadingSession>> all() {
    return _db
        .collection("reading_sessions")
        .orderBy("startTime", descending: false)
        .snapshots()
        .map((QuerySnapshot qsnap) => _transformQsnap(qsnap));
  }

  static Future<List<ReadingSession>> asyncAll() async {
    QuerySnapshot qsnap = await _db
        .collection("reading_sessions")
        .orderBy("startTime", descending: false)
        .getDocuments();
    return _transformQsnap(qsnap);
  }

  static Future<void> insert(ReadingSession session) {
    assert(session.id != null, "Reading Session must have ID to insert");
    return _db
        .collection("reading_sessions")
        .document(session.id)
        .setData(session.toMap());
  }

  static Future<void> delete(String id) {
    return _db.collection("reading_sessions").document(id).delete();
  }

  static Future<void> start() async {
    List<ReadingSession> sessions = await ReadingSession.asyncAll();
    int startPage;
    if (sessions.length >= 1) {
      ReadingSession prevSession = sessions.last;
      startPage = prevSession.endPage;
    }
    Map<String, dynamic> data = {
      "startTime": DateTime.now(),
    };
    if (startPage != null) {
      data["startPage"] = startPage;
    }
    DocumentReference docRef =
        await _db.collection("reading_sessions").add(data);
    return docRef.setData({"id": docRef.documentID}, merge: true);
  }

  static Future<void> stop({@required int endPage}) async {
    List<ReadingSession> sessions = await ReadingSession.asyncAll();
    ReadingSession activeSession = sessions.last;
    return _db
        .collection("reading_sessions")
        .document(activeSession.id)
        .setData({
      "endTime": DateTime.now(),
      "endPage": endPage,
    }, merge: true);
  }

  static bool isActive(List<ReadingSession> session) {
    try {
      ReadingSession lastSession = session.last;
      return lastSession.isIncomplete();
    } catch (error) {
      return false;
    }
  }
}

List<ReadingSession> _transformQsnap(QuerySnapshot qsnap) {
  List<DocumentSnapshot> snaps = qsnap.documents;
  List<Map<String, dynamic>> maps = snaps.map((snap) => snap.data).toList();
  List<ReadingSession> sessions =
      maps.map((map) => ReadingSession.fromMap(map)).toList();
  return sessions;
}
