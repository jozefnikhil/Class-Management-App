import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6_2/Panels/students.dart';
import 'package:flutter_application_6_2/Panels/teacher.dart';
import 'package:flutter_application_6_2/Screens/Registration.dart';

class Splashscreen1 extends StatefulWidget {
  const Splashscreen1({super.key});

  @override
  State<Splashscreen1> createState() => _Splashscreen1State();
}

class _Splashscreen1State extends State<Splashscreen1> {
  @override
  void initState() {
    super.initState();
    _checkrole();
  }

  User? user = FirebaseAuth.instance.currentUser;
  Future _checkrole() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      role = snap['role'];
    });
    if (role == 'Student') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Studentuser()));
    } else if (role == 'Teacher') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Teacheradmin()));
    } else {
      const Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
          child: LinearProgressIndicator(),
        ),
        SizedBox(
          height: 5,
        ),
        Center(child: Text('Fetching Account'))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Center(
                child: Text(
                  'Fetching Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            CircularProgressIndicator(
              color: Color.fromARGB(255, 76, 173, 175),
              strokeWidth: 5,
            ),
          ],
        )
      ]),
    );
  }
}
