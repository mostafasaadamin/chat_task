import 'package:chat/screens/chat/bloc/chars_bloc.dart';
import 'package:chat/screens/chat/bloc/chars_event.dart';
import 'package:chat/screens/users/bloc/users_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/remote/auth_repository.dart';
import '../../repository/remote/chat_repository.dart';

class ChatScreen extends StatelessWidget {
  String userId;
  String chatUserId;

  ChatScreen({required this.userId,required  this.chatUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsBloc(chatRepository: ChatRepository(),userId: userId,userTargetId: chatUserId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatsBloc>().add(ChatsLoadingEvent());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _ChatBody()), // The list of messages
        ChatInput(), // The input field
      ],
    );
  }
}

class _ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        // Incoming message
        _ChatBubble(
          message: 'Holy hell! 🤯',
          isOutgoing: false,
          senderName: 'Tracy',
          isDarkTheme: Theme.of(context).brightness == Brightness.dark,
        ),
        // Outgoing message
        _ChatBubble(
          message: 'What is that? Is that a script?',
          isOutgoing: true,
          senderName: 'You',
          isDarkTheme: Theme.of(context).brightness == Brightness.dark,
        ),
        // More messages...
      ],
    );
  }
}
class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isOutgoing;
  final String senderName;
  final bool isDarkTheme;

  const _ChatBubble({
    required this.message,
    required this.isOutgoing,
    required this.senderName,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isOutgoing) Text(senderName, style: TextStyle(color: Colors.grey)),
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 4),
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isOutgoing
                  ? (isDarkTheme ? Colors.green[800] : Colors.green[200])
                  : (isDarkTheme ? Colors.grey[700] : Colors.grey[300]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message,
              style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
class ChatInput extends StatelessWidget {
  TextEditingController _textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Message...',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: () {
             context.read<ChatsBloc>().add(SendChatEvent(_textEditingController.text,));
            },
          ),
        ],
      ),
    );
  }
}
