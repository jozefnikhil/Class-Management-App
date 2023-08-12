import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6_2/Screens/Registration.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Panels/dashboardpage.dart';

class Login1 extends StatefulWidget {
  const Login1({super.key});
  @override
  State<Login1> createState() => _Login1State();
}

User? user = FirebaseAuth.instance.currentUser;

class _Login1State extends State<Login1> {
  bool _passenable = true;
  String? errorMessage;
  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        'Welcome Back',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Enter your email and password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: email,
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                        onSaved: (value) {
                          email.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)),
                            fillColor: const Color.fromARGB(255, 0, 0, 0),
                            prefixIconColor: const Color.fromARGB(255, 0, 0, 0),
                            contentPadding: const EdgeInsets.all(12)),
                      )),
                      const SizedBox(
                        height: 12,
                      ),
                      Flexible(
                          child: TextFormField(
                              controller: password,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return 'Please Enter your Password';
                                }
                                if (!regex.hasMatch(value)) {
                                  return 'Please Enter Valid Password min 6 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                password.text = value!;
                              },
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20),
                              obscureText: _passenable,
                              cursorColor: const Color.fromARGB(255, 0, 0, 0),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  alignLabelWithHint: true,
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  prefixIconColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  hintText: 'Password',
                                  contentPadding: const EdgeInsets.all(12),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passenable = !_passenable;
                                      });
                                    },
                                    child: Icon(
                                      _passenable
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      login(email.text, password.text);
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 0, 0, 0)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  221, 255, 255, 255)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)))),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 22),
                                  )))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600)),
                            Flexible(
                                child: GestureDetector(
                                    child: InkWell(
                              onHighlightChanged: (value) {},
                              child: const Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Registration1()));
                              },
                            )))
                          ]),
                    ]),
              )),
        ),
      )
    ]));
  }

  void login(
    String email,
    String password,
  ) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {Fluttertoast.showToast(msg: 'Login Successfull')})
          .catchError((e) {
        Fluttertoast.showToast(msg: 'Login Failed!!!Check Email or Password');
        return e;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Splashscreen1()));
    }
  }
}
