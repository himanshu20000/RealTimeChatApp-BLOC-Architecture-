import 'package:chatapp_realtime/Modals/UserModal.dart';
import 'package:chatapp_realtime/blocs/User/userbloc.dart';
import 'package:chatapp_realtime/screens/socketTest.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _checkAuthStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken != null) {
      final token = authToken.split('=')[1]; 

      final userResponse = await http.get(
        Uri.parse('https://realtimechat-backend-xd9h.onrender.com/api/auth/'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
      );

      final userResponses = jsonDecode(userResponse.body);
      print("Auth data is $userResponses and status is ${userResponse.statusCode}");

      if (userResponse.statusCode == 200) {
        final responseData = jsonDecode(userResponse.body);
        if (responseData['user'] != null) {
          final user = UserModel.fromJson(responseData['user']);
          context.read<UsernameCubit>().setUsername(user.username);

          final username = context.read<UsernameCubit>().getUsername();
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SocketPage(username: username ?? "User AB"),
            ),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     Future.delayed(
        Duration(seconds: 1),
        () {
          _checkAuthStatus(context); 
        },);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/splashIcon.json'),
      ),
    );
  }
}
