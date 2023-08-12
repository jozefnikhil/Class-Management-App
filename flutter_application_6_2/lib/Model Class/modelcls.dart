import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  int? uid;
  String? name;
  String? address;
  int? phnum;
  String? fname;
  String? mname;
  var email;
  var role;

  Students(
      {this.uid,
      this.name,
      this.address,
      this.phnum,
      this.fname,
      this.mname,
      this.email,
      this.role});

  // factory Students.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) 
  //     {
  //   final data = document.data()!;
  //   return Students(
  //       // uid: document.id,
  //       name: data['name'],
  //       address: data['address'],
  //       phnum: data['phnum'],
  //       fname: data['fname'],
  //       mname: data['mname'],
  //       email: data['email'],
  //       role: data['role']);
  // }

  Map<String, dynamic> toMap() {
    return {
      'ID': uid,
      'Name': name,
      'Address': address,
      'Mobile': phnum,
      'Father Name': fname,
      'Mother Name': mname,
      'Email': email,
      'Role': role
    };
  }
}
