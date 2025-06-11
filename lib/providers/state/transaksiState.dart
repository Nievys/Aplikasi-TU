part of 'package:aplikasikkp/providers/bloc/transaksiCubit.dart';

abstract class transaksiState {
}

class transaksiInitial extends transaksiState {}

class transaksiLoading extends transaksiState {}

class transaksiSuccess extends transaksiState {
  final String message;
  transaksiSuccess({required this.message});
}

class transaksiFailure extends transaksiState {
  final String message;
  transaksiFailure({required this.message});
}