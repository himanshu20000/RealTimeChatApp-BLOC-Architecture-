import 'package:bloc/bloc.dart';
import 'package:chatapp_realtime/Modals/UserModal.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class SignupEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const SignupEvent({required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final UserModel user;
  final String message;

  const AuthLoginSuccessState({required this.user, required this.message});

  @override
  List<Object> get props => [user, message];
}


class AuthSignupSuccessState extends AuthState {
  final String message;

  const AuthSignupSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthFailureState extends AuthState {
  final String errorMessage;

  const AuthFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final response = await http.post(
          Uri.parse('https://realtimechat-backend-xd9h.onrender.com/api/auth/signIn'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': event.username,
            'password': event.password,
          }),
        );


        print("Status: ${response.statusCode}");
        print("Response: ${response.body}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final token = responseData['token'];

          if (token != null) {
            print("Cookie: $token");
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token',"token=$token"); 

            final userResponse = await http.get(
              Uri.parse('https://realtimechat-backend-xd9h.onrender.com/api/auth/'),
              headers: {
                'Content-Type': 'application/json',
                'Cookie': 'token=$token',
              },
            );
            final userResponses= jsonDecode(userResponse.body);

            print("Auth data is $userResponses and status is ${userResponse.statusCode}");

            if (userResponse.statusCode == 200) {
         
              final responseData = jsonDecode(userResponse.body);
  if (responseData['user'] != null) {
    final user = UserModel.fromJson(responseData['user']);
    emit(AuthLoginSuccessState(user: user, message: 'Login Successful'));
  } else {
    emit(AuthFailureState(errorMessage: 'User data not found.'));
  }
            } else {
              emit(AuthFailureState(errorMessage: 'Failed to fetch user credentials.'));
            }
          } else {
            emit(AuthFailureState(errorMessage: 'Cookie not found in the response.'));
          }
        } else {
          final errorData = jsonDecode(response.body);
          emit(AuthFailureState(errorMessage: errorData['message'] ?? 'Invalid credentials.'));
        }
      } catch (e) {
        emit(AuthFailureState(errorMessage: 'Something went wrong.'));
        print('Error: $e');
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final response = await http.post(
          Uri.parse('https://realtimechat-backend-xd9h.onrender.com/api/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': event.username,
            'password': event.password,
            'emailId': event.email,
          }),
        );


        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          emit(AuthSignupSuccessState(message: responseData['message'] ?? 'Signup successful!'));
        } else {
          final errorData = jsonDecode(response.body);
          emit(AuthFailureState(errorMessage: errorData['message'] ?? 'Signup failed.'));
        }
      } catch (e) {
        emit(AuthFailureState(errorMessage: 'Something went wrong.'));
        print('Error: $e');
      }
    });
  }
}
