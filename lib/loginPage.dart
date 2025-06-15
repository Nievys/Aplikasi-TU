import 'dart:convert';
import 'dart:ffi';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/pages/ProfilePage.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;
import 'Utils/transaksiServices.dart';
import 'Utils/loginValidator.dart';
import 'Utils/deviceInfo.dart';
import 'auth/authBloc/auth_cubit.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPage();
}

class _loginPage extends State<loginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  var email, password, device_name;
  bool securetext =  true;

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: thiscolor.AppColor.backgroundcolor,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AL-MADINAH\nLogin", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: thiscolor.AppColor.judulLogincuy),
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
      );
  }
  void showMsg(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login() async{
    email = emailController.text;
    password = passwordController.text;
    final authCubit = context.read<AuthCubit>();

    device_name = await getDeviceName();

    var data = {
      'email' : email,
      'password' : password,
      'device_name' : device_name
    };

    authCubit.login(data);
  }
}