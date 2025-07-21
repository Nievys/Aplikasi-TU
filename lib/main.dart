import 'dart:convert';

import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/loginPage.dart';
import 'package:aplikasikkp/pages/splashPage.dart';
import 'package:aplikasikkp/providers/bloc/bottom_nav_cubit.dart';
import 'package:aplikasikkp/providers/bloc/transaksiCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/transaksiServices.dart';
import 'Utils/ColorNest.dart' as thiscolor;
import 'Utils/loginValidator.dart';
import 'Utils/localDB.dart';
import 'auth/authBloc/auth_cubit.dart';
import 'package:aplikasikkp/auth/authServices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final authService = authServices();
    final storageService = StorageService();
    final transactionStorageService = TransactionStorageService(localDB());
    final transaksiServcies = transaksiServices();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => bottomnavcubit()),
        BlocProvider(create: (_) => AuthCubit(authService, storageService)..checkLoginStatus()),
        BlocProvider(create: (_) => transaksiCubit(transaksiServcies, transactionStorageService)),
      ],
      child: GetMaterialApp(
        home: const AuthHandler(),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return SplashPage();
        } else if (state is AuthAuthenticated) {
          return const Screenview();
        } else if (state is AuthUnauthenticated) {
          return const loginPage();
        } else if (state is AuthFailure) {
          return const loginPage();
        } else if (state is AuthLoading) {
          return CircularProgressIndicator();
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown state')),
          );
        }
      },
    );
  }
}