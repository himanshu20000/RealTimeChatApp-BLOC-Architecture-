import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class ChatRoomEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrJoinRoom extends ChatRoomEvent {
  final String roomId;
  final String username;
  final String fcmToken;

  CreateOrJoinRoom(this.roomId, this.username, this.fcmToken);


  @override
  List<Object?> get props => [roomId];
}

abstract class ChatRoomState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomSuccess extends ChatRoomState {
  final String roomId;
  ChatRoomSuccess(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class ChatRoomError extends ChatRoomState {
  final String message;
  ChatRoomError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  late IO.Socket _socket;
  String _username = '';
  String? _fcmToken;

  ChatRoomBloc() : super(ChatRoomInitial()) {
    _setupSocketConnection();
    on<CreateOrJoinRoom>(_onCreateOrJoinRoom);
    _fetchFcmToken();
  }

  void _setupSocketConnection() {
    _socket = IO.io('https://realtimechat-backend-xd9h.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('Connected to the server');
      _registerRoomEvents();
    });

    _socket.onDisconnect((_) => print('Disconnected from the server'));
  }

  Future<void> _fetchFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _fcmToken = await messaging.getToken();
    print('FCM Token: $_fcmToken');
  }

  void _registerRoomEvents() {
    _socket.on('roomCreated', (data) {
      emit(ChatRoomSuccess(data['roomId']));
    });

    _socket.on('roomJoined', (data) {
      emit(ChatRoomSuccess(data['roomId']));
    });

    _socket.on('error', (data) {
      emit(ChatRoomError(data['message']));
    });
  }

  Future<void> _onCreateOrJoinRoom(CreateOrJoinRoom event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomLoading());

    if (event.fcmToken == null) {
      emit(ChatRoomError('Failed to fetch FCM token.'));
      return;
    }

    final completer = Completer<void>();

    _socket.emit('createOrJoinRoom', [event.roomId, event.username, event.fcmToken]);

    _socket.once('roomCreated', (data) {
      emit(ChatRoomSuccess(data['roomId']));
      completer.complete();
    });

    _socket.once('roomJoined', (data) {
      emit(ChatRoomSuccess(data['roomId']));
      completer.complete();
    });

    _socket.once('error', (data) {
      emit(ChatRoomError(data['message']));
      completer.completeError(data['message']);
    });

    await completer.future;
  }

  void sendMessage(String roomId, String message) {
    _socket.emit('sendMessage', {
      'room': roomId,
      'message': message,
      'sender': _username,
    });
  }
}
