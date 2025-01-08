import 'package:chatapp_realtime/Colors/colors.dart';
import 'package:chatapp_realtime/blocs/chatRoombloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ChatRoomPage extends StatelessWidget {
  final String roomId;
  final String username;
  final TextEditingController _messageController = TextEditingController();

  ChatRoomPage({Key? key, required this.roomId, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: clr2,
      appBar: AppBar(
          backgroundColor: clr2,
        title: Text('Chat Room: $roomId'),
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.close,size: height*0.021,),onPressed:() {Navigator.pop(context);},),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatRoomsBloc, ChatRoomState>(
              builder: (context, state) {
                if (state is ChatRoomLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatRoomLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isUserMessage = message['sender'] == username;

                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: height*0.001,horizontal: height*0.01),
                        child: Row(
                          mainAxisAlignment:
                              isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                          
                            
                            Column(
                              
                              crossAxisAlignment: isUserMessage
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                          
                                 
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom:height*0.01 ),
                                  decoration: BoxDecoration(
                                    color: isUserMessage
                                        ? Colors.blueAccent
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                     crossAxisAlignment: isUserMessage
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.start,
                                    children: [
                                       Row(
                                     mainAxisAlignment:
                            isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircleAvatar(
                                          backgroundColor: isUserMessage?Colors.lightGreen:Colors.yellow,
                                                                          child: Center(child: Text(message['sender']![0],style: TextStyle(color: isUserMessage? Colors.white:Colors.grey,fontSize: height*0.016),)),
                                                                          
                                                                        ),
                                      ),
                                      SizedBox(width: height*0.01,),
                                      Text(
                                        message['sender']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isUserMessage? Colors.white:Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height*0.005,),
                                      Text(
                                        message['message']!,
                                        style: TextStyle(
                                          color: isUserMessage ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                           
                          ],
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('No messages yet.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ChatRoomsBloc>().add(SendMessage(roomId, message, username));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
