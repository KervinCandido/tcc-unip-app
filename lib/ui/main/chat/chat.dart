import 'dart:io';

import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/dao/messageDAO.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/message.dart';
import 'package:app_tcc_unip/model/messageForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Chat extends StatefulWidget {
  final ContactRecommendation contact;
  final int userId;
  const Chat(this.contact, this.userId, {Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState(this.contact, this.userId);
}

class _ChatState extends State<Chat> {
  final ContactRecommendation contact;
  final _messageDAO = MessageDAO();
  List<Message> messagemList = [];

  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int userId;

  _ChatState(this.contact, this.userId) {
    _webSocketController.addMessageListener(onMessage);
  }

  @override
  void dispose() {
    _webSocketController.removeMessageListener(onMessage);
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  onMessage(MessageForm message) {
    setState(() {
      messagemList.add(Message(
        userId,
        this.contact.userName,
        message.content,
        false,
        DateTime.now(),
      ));
    });
  }

  final _webSocketController = WebsocketController.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _messageDAO.messageList(userId),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Message>> snapshot,
      ) {
        if (snapshot.hasData) {
          messagemList.clear();
          messagemList.addAll(snapshot.requireData);

          SchedulerBinding.instance!.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent + 50);
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
                        : Image.file(File(this.contact.photoProfile!)).image,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(this.contact.profileName),
                ],
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(top: 5, right: 5, bottom: 60, left: 5),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messagemList.length,
                itemBuilder: (itemBuilder, index) {
                  print(messagemList[index].isSend);
                  var bubbleType = messagemList[index].isSend
                      ? BubbleType.sendBubble
                      : BubbleType.receiverBubble;
                  return ChatBubble(
                    clipper: ChatBubbleClipper1(type: bubbleType),
                    alignment:
                        messagemList[index].isSend ? Alignment.topRight : null,
                    margin: EdgeInsets.only(top: 10),
                    backGroundColor: Theme.of(context).primaryColor,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        messagemList[index].message,
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
        return const SpinKitSpinningLines(
          color: Colors.redAccent,
        );
      },
    );
  }

  void sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    this.messagemList.add(
          Message(
            userId,
            this.contact.userName,
            _textController.text.trim(),
            true,
            DateTime.now(),
          ),
        );
    setState(() {
      _webSocketController.send(_textController.text, this.contact.userName);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _textController.clear();
    });
  }
}
