import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  final String id;
  String? docId;
  final String name;
  final String description;

  Categories(
      {required this.id,
      this.docId,
      required this.name,
      required this.description});

  factory Categories.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Categories(
      id: data['id'],
      docId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
