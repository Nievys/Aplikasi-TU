import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasikkp/auth/authServices.dart';


part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  final authServices AuthServices;
  final StorageService storageService;

  AuthCubit(this.AuthServices, this.storageService) : super(AuthInitial());

  void login(logindata) async {
    emit(AuthLoading());
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var data = await AuthServices.loginjwt(logindata);
      localStorage.setString('decryption_key', data.decryptKey);
      localStorage.setInt('account_id', data.userWhoLogged.account_id);
      localStorage.setString('name', data.userWhoLogged.name);
      localStorage.setString('email', data.userWhoLogged.email);
      localStorage.setString('role', data.userWhoLogged.role);
      await storageService.saveToken(data.token);
      emit (AuthAuthenticated(token : data.token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    emit(AuthInitial()); // ganti state jadi authloading biar jadi tampilan loading
    try {
      final token = await storageService.getToken();
      if (token != null && token.isNotEmpty) {
        var response = await AuthServices.checkLogin(token);
        print(token);
        if (response.message == "success") {
          emit(AuthAuthenticated(token: token));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: "Error"));
    }
  }

  Future<void> logout() async {
    await storageService.deleteToken();
    emit(AuthUnauthenticated());
  }
}