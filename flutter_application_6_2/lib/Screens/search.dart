import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search1 extends StatefulWidget {
  const Search1({super.key});

  @override
  State<Search1> createState() => _Search1State();
}

int id = 0;
final _controller = TextEditingController();
String _searchText = "";
String lowercase_SearchText = _searchText.toLowerCase();

class _Search1State extends State<Search1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Card(
                child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                      ;
                    }))),
        body: StreamBuilder<QuerySnapshot>(
            stream: (_searchText != "")
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where('Name', isGreaterThanOrEqualTo: _searchText)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('Name')
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final doc = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    final data = doc[index];

                    return ListTile(
                      title: Text(data['Name']),
                    );
                  });
            }));
  }
}
