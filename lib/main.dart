import 'package:chatapp_realtime/Methods/NotificationMethods.dart';
import 'package:chatapp_realtime/blocs/AuthBloc/authBloc.dart';
import 'package:chatapp_realtime/blocs/User/userbloc.dart';
import 'package:chatapp_realtime/blocs/chatRoombloc.dart';
import 'package:chatapp_realtime/blocs/chatbloc.dart';
import 'package:chatapp_realtime/firebase_options.dart';
import 'package:chatapp_realtime/screens/SplashScreen/splashscreen.dart';
import 'package:chatapp_realtime/screens/authScreen/loginScreen.dart';
import 'package:chatapp_realtime/screens/authScreen/signupScreen.dart';
import 'package:chatapp_realtime/screens/socketTest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Notificationmethods notificationMethods = Notificationmethods();
  await notificationMethods.initializeLocalNotifications(); 
    notificationMethods.listenToFCM(); 
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  notificationMethods.requestNotificationPermission();

  final IO.Socket socket = IO.io(
    'https://realtimechat-backend-xd9h.onrender.com/',
    <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    },
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ChatRoomBloc>(
          create: (context) => ChatRoomBloc(),
        ),
        BlocProvider<ChatRoomsBloc>(
          create: (context) => ChatRoomsBloc(socket),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<UsernameCubit>(
          create: (context) => UsernameCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => SplashScreen(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/socketInitial':(context) =>  SocketPage(username: "UserA",),
      },
    );
  }
}

