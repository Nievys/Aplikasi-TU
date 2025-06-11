import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class bottomnavcubit extends Cubit<int> {
  bottomnavcubit() : super(0);
  changeSelectedPage(int index) => emit(index);
}