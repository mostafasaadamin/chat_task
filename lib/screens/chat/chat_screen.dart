import 'package:chat/screens/chat/bloc/chars_bloc.dart';
import 'package:chat/screens/chat/bloc/chars_event.dart';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:chat/screens/users/bloc/users_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../../const/const_strings.dart';
import '../../repository/remote/auth_repository.dart';
import '../../repository/remote/chat_repository.dart';
import '../../utils/colors.dart';

class ChatScreen extends StatelessWidget {
  String userId;
  String chatUserId;
  String userName;

  ChatScreen({required this.userId,required  this.chatUserId,required  this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsBloc(chatRepository: ChatRepository(),userId: userId,userTargetId: chatUserId,userName: userName),
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
    return BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsFailure) {
            return Center(child: Text(state.error));
          } else if (state is ChatsLoaded) {
            final messages = state.messages;
            return
              ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final messageData = messages[index].data() as Map<String,
                      dynamic>;

                  return _ChatBubble(
                    message: messageData['message'],
                    isOutgoing: messageData['senderId']==context.read<ChatsBloc>().userId,
                    senderName: messageData['userName']??"",
                    isDarkTheme: Theme
                        .of(context)
                        .brightness == Brightness.dark,
                  );
                },
              );
          }else {
            return Container();
          }
        });
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
    return  !isOutgoing&&typingMessageCode==message?
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        JumpingDots(
          color: primaryColor!,
          radius: 8,
          numberOfDots: 3,
          animationDuration : Duration(milliseconds: 200),
        ),
      ],
    ):
    typingMessageCode!=message?
     Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isOutgoing) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(senderName, style: TextStyle(color: Colors.grey)),
          ),
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
    ):SizedBox.shrink();
  }
}
class ChatInput extends StatefulWidget {
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        context.read<ChatsBloc>().add(TypingEvent(typingMessageCode));
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
      if (state is MessageSent) {
       _textEditingController.clear();
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode:_focusNode ,
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
                _focusNode.unfocus();
                context.read<ChatsBloc>().add(SendChatEvent(_textEditingController.text,));
              },
            ),
          ],
        ),
      );
      },

    );




  }
}
