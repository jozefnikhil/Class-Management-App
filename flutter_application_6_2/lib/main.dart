import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Panels/dashboardpage.dart';
import 'Screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Data1());
}

class Data1 extends StatefulWidget {
  const Data1({super.key});

  @override
  State<Data1> createState() => _Data1State();
}

class _Data1State extends State<Data1> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? const Splashscreen1() : const Login1(),
    );
  }
}
