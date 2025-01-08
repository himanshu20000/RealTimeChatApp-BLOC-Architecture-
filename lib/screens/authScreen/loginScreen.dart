import 'package:chatapp_realtime/Colors/colors.dart';
import 'package:chatapp_realtime/blocs/AuthBloc/authBloc.dart';
import 'package:chatapp_realtime/screens/socketTest.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Future.delayed(Duration(seconds: 0), () {
    setState(() {
      isAnimate = true;
    });
  });

  }
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Successful')),
            );
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SocketPage(username: state.user.username),
            ),
          );
          } else if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: Container(
          height: height,
          width: width,
          color: clr1,
          child: Stack(
            children: [
              Positioned(
                top: height*0.33,
                left: height*0.01,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: height*0.055,fontWeight: FontWeight.bold,color: clr3),
                    ),
                     Text(
                      "Its always great to see",
                      style: TextStyle(fontSize: height*0.025,fontWeight: FontWeight.bold,color: clr3),
                    ),
                  ],
                )
              ),
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: isAnimate? height*0.5:height*0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(height*0.02),
                      topRight: Radius.circular(height*0.02)
          
                      ),
                    color: clr2
                  ),
                 
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Visibility(
                      visible: isAnimate,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(isAnimate)
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(labelText: 'Username'),
                          ),
                          if(isAnimate)
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          if(isAnimate)
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            },
                            child: Text('Login'),
                          ),
                          SizedBox(height: 20),
                          if(isAnimate)
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text('Don\'t have an account? Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
