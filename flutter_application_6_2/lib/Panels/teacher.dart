import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6_2/Screens/login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'crud.dart';

class Teacheradmin extends StatefulWidget {
  const Teacheradmin({super.key});

  @override
  State<Teacheradmin> createState() => _TeacheradminState();
}

var customId = 0;

class _TeacheradminState extends State<Teacheradmin> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const Professor(),
    const Students1(),
    const Profile1()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.school_outlined,
                  text: 'Students List',
                ),
                GButton(
                  icon: Icons.person_2_outlined,
                  text: 'Profile',
                )
              ],
            )));
  }
}

Widget noofstudents(BuildContext context) {
  Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Student');
  return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          int totaldoc = snapshot.data!.docs.length;

          return ListTile(
            title: const Text('Total No.of Students'),
            leading: const Icon(Icons.group),
            trailing: Text(
              "$totaldoc",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

class Professor extends StatefulWidget {
  const Professor({super.key});

  @override
  State<Professor> createState() => _ProfessorState();
}

List<NetworkImage> images1 = [
  const NetworkImage(
      "https://thumbs.dreamstime.com/b/cartoon-child-going-to-school-illustration-children-beautiful-colorful-35897371.jpg"),
  const NetworkImage(
      'https://img.freepik.com/premium-vector/school-building-with-trees-isolated-white-background-outline-vector-illustration-cartoon-style_381012-23.jpg?w=2000')
];
List<Image> imageWidgets =
    images1.map((netImg) => Image.network(netImg.url)).toList();

class _ProfessorState extends State<Professor> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final String name = snapshot.data!['Name'];

              return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$greeting, $name',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 250,
                            child: CarouselSlider(
                              items: imageWidgets,
                              options: CarouselOptions(height: 400.0),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: noofstudents(context),
                          )
                        ]))),
              );
            }));
  }
}

class Profile1 extends StatefulWidget {
  const Profile1({super.key});

  @override
  State<Profile1> createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.white, actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              signOut1();
            },
          ),
        ]),
        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final String name = snapshot.data!['Name'];
              final String address = snapshot.data!['adress'];
              final String email = snapshot.data!['email'];

              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(padding: EdgeInsets.all(12)),
                    const Center(
                      child: CircleAvatar(
                        radius: 75,
                        foregroundImage: NetworkImage(
                            "https://img.freepik.com/free-vector/teacher-classroom-pointing-chalkboard_40876-2421.jpg"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        title: Column(children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            address,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(email,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                    )
                  ]));
            }));
  }
}
