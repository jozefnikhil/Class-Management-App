import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_6_2/Screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration1 extends StatefulWidget {
  const Registration1({super.key});

  @override
  State<Registration1> createState() => _Registration1State();
}

String? role;
String teacher = 'Teacher';
String student = 'Student';
bool _passenable = true;

class _Registration1State extends State<Registration1> {
  late String error = 'Check any fields invalid or used before';
  String? errorMessage;

  final _address = TextEditingController();
  final _email = TextEditingController();
  final _fname = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _mname = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _phnum = TextEditingController();

  Future submit(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email.text, password: _password.text))
            .user;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'uid': user.uid,
          'Name': _name.text,
          'adress': _address.text,
          'mobile': _phnum.text,
          'fname': _fname.text,
          'mname': _mname.text,
          'email': _email.text,
          'role': role,
          'createdAt': FieldValue.serverTimestamp()
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login1()));
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed with error code: $e');
        Fluttertoast.showToast(msg: error.toString());
        return e.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(115, 45, 45, 45),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Lets Register \nAccount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color.fromARGB(255, 0, 0, 0))),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          'Hello user , you have \na grateful journey',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _name,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{3,}$');
                                  if (value!.isEmpty) {
                                    return ("Name cannot be Empty");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid name(Min. 3 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name.text = value!;
                                },
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Name',
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _address,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{3,}$');
                                  if (value!.isEmpty) {
                                    return ("Address cannot be Empty");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid Address(Min. 6 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _address.text = value!;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      (RegExp('[a-z A-Z]')))
                                ],
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Address',
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _phnum,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  RegExp regex =
                                      RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
                                  if (value!.isEmpty) {
                                    return ("Mobile number cannot be Empty");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid Number(Min. 10 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _phnum.text = value!;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                keyboardType: TextInputType.phone,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Mobile Number',
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _fname,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{3,}$');
                                  if (value!.isEmpty) {
                                    return ("Father name cannot be Empty");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid name(Min. 3 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _fname.text = value!;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                keyboardType: TextInputType.name,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: "Father's Name",
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _mname,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{3,}$');
                                  if (value!.isEmpty) {
                                    return ("Mother Name cannot be Empty");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid Name(Min. 3 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _mname.text = value!;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                keyboardType: TextInputType.name,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: "Mother's Name",
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _email,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                validator: (value) =>
                                    EmailValidator.validate(value!)
                                        ? null
                                        : "Please enter a valid email",
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Email',
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(11),
                            child: TextFormField(
                                controller: _password,
                                textInputAction: TextInputAction.next,
                                obscureText: _passenable,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Password is required for login");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid Password(Min. 6 Character)");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password.text = value!;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19),
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    hintText: 'Password',
                                    fillColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    contentPadding: const EdgeInsets.all(10),
                                    hintStyle: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
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
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    )))),
                        Padding(
                          padding: const EdgeInsets.all(11),
                          child: SizedBox(
                            width: 300,
                            height: 100,
                            child: DropdownButtonFormField<String>(
                              itemHeight: 50,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 25),
                              value: role,
                              hint: const Text(
                                'Select Role',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 23),
                              ),
                              dropdownColor:
                                  const Color.fromARGB(221, 255, 255, 255),
                              onChanged: (selectrole) =>
                                  setState(() => role = selectrole),
                              validator: (value) =>
                                  value == null ? 'Please select role' : null,
                              onSaved: (value) => role = value,
                              items: [
                                teacher,
                                student
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Center(
                            child: SizedBox(
                                width: 300,
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: () {
                                      submit(_email.text, _password.text);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    255, 0, 0, 0)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)))),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 23, color: Colors.white),
                                    )))),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600)),
                              Flexible(
                                  child: GestureDetector(
                                child: const Text('Login',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Login1()));
                                },
                              ))
                            ]),
                        const SizedBox(
                          height: 20,
                        )
                      ]))),
        ));
  }
}
