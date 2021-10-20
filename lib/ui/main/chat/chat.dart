import 'dart:convert';

import 'package:app_tcc_unip/model/contact.dart';
import 'package:app_tcc_unip/ui/main/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';

class Chat extends StatefulWidget {
  final Contact contact;

  const Chat(this.contact, {Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState(this.contact);
}

class _ChatState extends State<Chat> {
  final Contact contact;

  final List<Message> _messagems = [
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("olá", MessageType.SEND),
    Message("oi, tudo bem ?", MessageType.RECEIVER),
    Message("não", MessageType.SEND),
    Message("..........", MessageType.RECEIVER),
  ];

  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _ChatState(this.contact);

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
              backgroundImage: this.contact.photo == null
                  ? null
                  : Image.memory(base64Decode(this.contact.photo!)).image,
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
            Message(
              _textController.text.trim(),
              MessageType.SEND,
            ),
          );
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _textController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
