import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6_2/Panels/teacher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Screens/search.dart';

class Students1 extends StatefulWidget {
  const Students1({super.key});

  @override
  State<Students1> createState() => _Students1State();
}

TextEditingController _name = TextEditingController();
TextEditingController _phnum = TextEditingController();
TextEditingController _fname = TextEditingController();
TextEditingController _mname = TextEditingController();

class _Students1State extends State<Students1> {
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Scaffold newMethod(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text('Students list',
                style: TextStyle(
                  color: Colors.black87,
                )),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Search1()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black87,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'Student')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final doc = snapshot.data!.docs;
              return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  final data = doc[index];
                  var docId = snapshot.data!.docs[index].id;
                  return GestureDetector(
                      child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.all(4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Card(
                              child: ExpansionTile(
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            leading: const Icon(Icons.square),
                            title: Text("${data['Name']}"),
                            trailing: Text("Mob:${data['mobile']}"),
                            childrenPadding: const EdgeInsets.all(8),
                            children: [
                              ListTile(
                                  leading: const Icon(Icons.person_2_outlined),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _name.text = data['Name'];
                                      _fname.text = data['fname'];
                                      _mname.text = data['mname'];
                                      _phnum.text = data['mobile'];

                                      edit(context, snapshot, docId);
                                    },
                                    icon: const Icon(
                                        Icons.mode_edit_outline_outlined),
                                  ),
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Address:${data['adress']}",
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Father Name:${data['fname']}"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Mother Name:${data['mname']}"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Email:${data['email']}"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ))
                            ],
                          ))));
                },
              );
            }));
  }

  edit(context, snapshot, String docId) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
                child: ListView(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: _fname,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Father Name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: _mname,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Mother Name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        validator: (value) {
                          RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
                          if (value!.isEmpty) {
                            return ("Mobile number cannot be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Number(Min. 10 Character)");
                          }
                          return null;
                        },
                        controller: _phnum,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Mobile Number',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )))),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                updatedata1(docId);
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: 'Details Updated',
                                    timeInSecForIosWeb: 3);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 72, 142, 161)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)))),
                              child: const Text(
                                'Update',
                                style: TextStyle(fontSize: 23),
                              )))),
                ),
                Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  delete1(docId);
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: 'Document Deleted',
                                      timeInSecForIosWeb: 3);
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(255, 219, 37, 37)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)))),
                                child: const Text('Delete',
                                    style: TextStyle(fontSize: 23))))))
              ],
            )));
  }

  updatedata1(docId) {
    FirebaseFirestore.instance.collection('users').doc(docId).update({
      'Name': _name.text,
      'mobile': _phnum.text,
      'fname': _fname.text,
      'mname': _mname.text
    });
  }

  delete1(docId) async {
    FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return newMethod(context);
  }
}
