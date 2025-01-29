import 'dart:convert';

import 'package:aplikasikkp/ScreenView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Methods/api.dart';
import 'Utils/ColorNest.dart' as thiscolor;
import 'Utils/loginValidator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  logincuy createState() => logincuy();
}

class logincuy extends State<MyApp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = true;

  var email, password;
  bool securetext =  true;

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passwordController.text = '';
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      Get.to(() => const Screenview());
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: thiscolor.AppColor.backgroundcolor,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "AL-MADINAH\nStaff Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: thiscolor.AppColor.judulLogincuy),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          validator: LoginValidators.validateEmail,
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.person_outline_outlined),
                            ),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          ),
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: securetext,
                          validator:  LoginValidators.validatePassword,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.lock_outline),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  securetext = !securetext;
                                });
                              },
                              padding: EdgeInsets.only(right: 10),
                              icon: Icon(securetext ? Icons.visibility_off : Icons.visibility),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          ),
                          controller: passwordController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(thiscolor.AppColor.ijoButton),
                    foregroundColor: MaterialStateProperty.all(thiscolor.AppColor.buttonColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    elevation: MaterialStateProperty.all(10),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    } else {
                      print('Form tidak valid');
                    }
                  },
                  child: Text("login".toUpperCase()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showMsg(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login() async{
    setState(() {
      loading = true;
    });
    email = emailController.text;
    password = passwordController.text;

    var data = {
      'email' : email,
      'password' : password
    };

    var res = await Network().auth(data, '/login');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => Screenview()
        ),
      );
    }else{
      showMsg(body['message']);
    }

    setState(() {
      loading = false;
    });
  }
}