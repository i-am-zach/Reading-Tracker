import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Firestore _db = Firestore.instance;

class Book {
  final String id;
  final String title;
  final String author;
  final int pages;

  Book({
    this.id,
    @required this.title,
    @required this.author,
    @required this.pages,
  });

  Map<String, dynamic> toMap() => ({
        "id": id,
        "title": title,
        "author": author,
        "pages": pages,
      });

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, pages: $pages}';
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
        id: data["id"],
        title: data["title"],
        author: data["author"],
        pages: data["pages"]);
  }

  static Stream<List<Book>> all() {
    return _db
        .collection("books")
        .snapshots()
        .map((QuerySnapshot qsnap) => _transformQsnap(qsnap));
  }

  static Future<void> insert(Book book) {
    assert(book.id != null, "ID Must be provided");
    return _db
        .collection("books")
        .document(book.id)
        .setData(book.toMap(), merge: true);
  }

  static Future<void> delete(String id) {
    return _db.collection("books").document(id).delete();
  }

  static String generateID(String title, String author) {
    RegExp acceptedChars = new RegExp("[a-zA-Z0-9]+");
    List<String> matches = acceptedChars
        .allMatches("$title $author")
        .map((RegExpMatch mo) => mo.group(0) ?? "").toList();
    return matches.join("_").toLowerCase();
  }
}

List<Book> _transformQsnap(QuerySnapshot qsnap) {
  List<DocumentSnapshot> snaps = qsnap.documents;
  List<Map<String, dynamic>> maps = snaps.map((snap) => snap.data).toList();
  List<Book> books = maps.map((map) => Book.fromMap(map)).toList();
  return books;
}
