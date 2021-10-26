import 'dart:convert';

import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contact.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/message.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/ui/main/chat/messageChat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class Chat extends StatefulWidget {
  final ContactRecommendation contact;

  const Chat(this.contact, {Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState(this.contact);
}

class _ChatState extends State<Chat> {
  final ContactRecommendation contact;

  final List<MessageChat> _messagems = [
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("olá", MessageType.SEND),
    // Message("oi, tudo bem ?", MessageType.RECEIVER),
    // Message("não", MessageType.SEND),
    // Message("..........", MessageType.RECEIVER),
  ];

  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _ChatState(this.contact) {
    _webSocketController.addMessageListener(onMessage);
  }

  @override
  void dispose() {
    _webSocketController.removeMessageListener(onMessage);
    super.dispose();
  }

  onMessage(Message message) {
    setState(() {
      _messagems.add(MessageChat(message.content, MessageType.RECEIVER));
    });
  }

  final _webSocketController = WebsocketController.getInstance();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              minRadius: 20,
              backgroundImage: this.contact.photoProfile == null
                  ? null
                  : Image.memory(base64Decode(this.contact.photoProfile!))
                      .image,
            ),
            SizedBox(
              width: 10,
            ),
            Text(this.contact.profileName),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, right: 5, bottom: 60, left: 5),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _messagems.length,
          itemBuilder: (itemBuilder, index) {
            var send = _messagems[index].type == MessageType.SEND;
            var bubbleType =
                send ? BubbleType.sendBubble : BubbleType.receiverBubble;
            return ChatBubble(
              clipper: ChatBubbleClipper1(type: bubbleType),
              alignment: send ? Alignment.topRight : null,
              margin: EdgeInsets.only(top: 10),
              backGroundColor: Theme.of(context).primaryColor,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  _messagems[index].text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: 50,
        color: Colors.white,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: _textController,
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (value) {
            sendMessage();
          },
          decoration: InputDecoration(
            contentPadding: new EdgeInsets.only(left: 16, right: 16),
            fillColor: Colors.white,
            hintText: 'Escreva sua mensagem',
            suffixIcon: GestureDetector(
              child: Icon(Icons.send),
              onTap: () {
                sendMessage();
                FocusScope.of(context).unfocus();
              },
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            focusedBorder: InputBorder.none,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    setState(() {
      if (_textController.text.trim().isEmpty) return;
      this._messagems.add(
            MessageChat(
              _textController.text.trim(),
              MessageType.SEND,
            ),
          );
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _webSocketController.send(_textController.text, this.contact.userName);
      _textController.clear();
    });
  }
}
