import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ChatRoomEvent {}

class SendMessage extends ChatRoomEvent {
  final String roomId;
  final String message;
  final String sender;

  SendMessage(this.roomId, this.message, this.sender);
}

class ReceiveMessage extends ChatRoomEvent {
  final String sender;
  final String message;

  ReceiveMessage(this.sender, this.message);
}

abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<Map<String, String>> messages;

  ChatRoomLoaded(this.messages);
}


class ChatRoomsBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final IO.Socket _socket;
  final List<Map<String, String>> _messages = [];

  ChatRoomsBloc(this._socket) : super(ChatRoomInitial()) {
    _socket.on('receiveMessage', (data) {
      if (data['sender'] != 'currentUser') { 
        add(ReceiveMessage(data['sender'], data['message']));
      }
    });

    on<SendMessage>((event, emit) {
      _socket.emit('sendMessage', {
        'room': event.roomId,
        'message': event.message,
        'sender': event.sender,
      });
    });

    on<ReceiveMessage>((event, emit) {
      _messages.add({'sender': event.sender, 'message': event.message});
      emit(ChatRoomLoaded(List.from(_messages))); 
    });
  }
}
