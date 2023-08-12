import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<T>> getCollection<T>(
      {required String path, required T builder(Map<String, dynamic> data)}) {
    // Reference to the Firestore collection
    final CollectionReference collection = _db.collection(path);

    // Get the snapshot of the collection
    return collection.snapshots().map((snapshot) {
      // Map the snapshot data to a list of objects
      return snapshot.docs
          .map((doc) => builder(doc.data as Map<String, dynamic>))
          .toList();
    });
  }
}

class MyModel {
  MyModel({required this.id, required this.name, required this.age});

  factory MyModel.fromMap(Map<String, dynamic> data) {
    return MyModel(
      id: data['id'],
      name: data['name'],
      age: data['age'],
    );
  }

  final int age;
  final String id;
  final String name;
}

class MyHomePage extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyModel>>(
      stream: _service.getCollection(
          path: 'users', builder: (data) => MyModel.fromMap(data)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.age.toString()),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
