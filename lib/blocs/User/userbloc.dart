import 'package:flutter_bloc/flutter_bloc.dart';

class UsernameCubit extends Cubit<String?> {
  UsernameCubit() : super(null); 
  void setUsername(String username) {
    emit(username);  
  }

  String? getUsername() {
    return state; 
  }
}
