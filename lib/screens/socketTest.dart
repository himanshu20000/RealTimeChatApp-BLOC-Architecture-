import 'package:chatapp_realtime/Colors/colors.dart';
import 'package:chatapp_realtime/blocs/chatbloc.dart';
import 'package:chatapp_realtime/screens/chatRoomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketPage extends StatefulWidget {
  final String username;

  const SocketPage({super.key, required this.username});
  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); 
  String? _username;
   @override
  void initState() {
    super.initState();

    if (widget.username.isNotEmpty) {
      _usernameController.text = widget.username; 
    }
  }
  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => ChatRoomBloc(),
      child: Scaffold(
        backgroundColor: clr2,
        appBar: AppBar(
          elevation: 0,
           backgroundColor: clr2,
          title: Text('Create or Join Room'),
            automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.close,size: height*0.021,),onPressed:() {Navigator.pop(context);},),
        ),
        body: BlocConsumer<ChatRoomBloc, ChatRoomState>(
          listener: (context, state) {
            if (state is ChatRoomSuccess) {
              final roomId = state.roomId;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ChatRoomBloc(),
                    child: ChatRoomPage(roomId: roomId, username: _username!), 
                  ),
                ),
              );
            } else if (state is ChatRoomError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatRoomLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      border: OutlineInputBorder(),
                      focusColor: Colors.white,
                      hoverColor: Colors.white
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _roomIdController,
                    decoration: InputDecoration(
                      
                      labelText: 'Enter Room ID',
                      border: OutlineInputBorder(),
                        focusColor: Colors.white,
                      hoverColor: Colors.white
                    ),
                  ),
                  SizedBox(height: 20),
                 ElevatedButton(
  onPressed: () async {
    final roomId = _roomIdController.text.trim();
    final username = _usernameController.text.trim();

    if (roomId.isNotEmpty && username.isNotEmpty) {
      setState(() {
        _username = username; 
      });
      print("Username is $_username");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final fcmToken = prefs.getString('fcm_token') ?? '';

      context.read<ChatRoomBloc>().add(CreateOrJoinRoom(roomId, username, fcmToken));
    }
  },
  child: Text('Join or Create Room'),
),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
