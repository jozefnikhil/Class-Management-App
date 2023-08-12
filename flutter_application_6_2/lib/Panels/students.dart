import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/login.dart';

class Studentuser extends StatefulWidget {
  const Studentuser({super.key});

  @override
  State<Studentuser> createState() => _StudentuserState();
}

class _StudentuserState extends State<Studentuser> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 15) {
      greeting = 'Good Afternoon';
    } else if (hour < 20) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                leading: const Icon(
                  Icons.grid_view_outlined,
                  color: Colors.black87,
                ),
                title: const Center(
                    child: Text(
                  'Student Portal',
                  style: TextStyle(color: Colors.black87),
                )),
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                      onPressed: () {
                        signOut1();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black87,
                      ))
                ]),
            body: Center(
                // ignore: sort_child_properties_last
                child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data?.data() == null) {
                        return const Text('No user data found.');
                      }

                      // Extract the username from the user's document in Firestore
                      final userData =
                          snapshot.data!.data()! as Map<String, dynamic>;
                      final userName = userData['Name'] as String;

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: CircleAvatar(
                                radius: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    "https://dm0qx8t0i9gc9.cloudfront.net/thumbnails/video/HGATaVJubj6casdeu/videoblocks-little-student-boy-reading-book-in-the-park-animated-character-4k-video-animation_htpryc1-w_thumbnail-1080_01.png",
                                    fit: BoxFit.fill,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListTile(
                                minLeadingWidth: 100,
                                title: Column(children: [
                                  const Text(
                                    'Welcome Back',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    ' $greeting, $userName',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]))
                          ]);
                    }))));
  }

  Future<Login1> signOut1() async {
    AlertDialog alert =
        AlertDialog(title: const Text('Do you want to Sign Out?'), actions: [
      SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 69, 142, 150),
                  disabledForegroundColor:
                      const Color.fromARGB(255, 0, 0, 0).withOpacity(0.38)),
              clipBehavior: Clip.hardEdge,
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login1()));
              },
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 205, 44, 44)),
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
      )
    ]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return const Login1();
  }
}
