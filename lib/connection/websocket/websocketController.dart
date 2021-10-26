import 'dart:convert';

import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/message.dart';
import 'package:app_tcc_unip/model/requestAddContact.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

const BASE_URL_API = 'BASE_URL_API';

class WebsocketController {
  static WebsocketController _instance = WebsocketController._();

  final List<Function(ContactRecommendation contactRecommendation)>
      _requestAddContact = [];

  final List<Function(Message message)> _messageListener = [];

  final String baseURL = dotenv.get(BASE_URL_API);
  final _tokenService = TokenService();
  final _userService = UserService();

  late StompClient stompClient;
  late String _userName;

  bool isActive = false;

  WebsocketController._();

  factory WebsocketController.getInstance() {
    return _instance;
  }

  active() async {
    if (isActive) {
      print('Já está ativo');
      deactivate();
      // return;
    }
    var token = await _tokenService.getTokenForResquest();
    _userName = await _userService.getUsernameCurrentUser() ?? '';
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: '$baseURL/chat',
        onConnect: _onConnect,
        webSocketConnectHeaders: {'Authorization': token},
      ),
    );
    stompClient.activate();
    isActive = true;
  }

  void _onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/user/$_userName/message/queue',
      callback: (frame) {
        var message = Message.fromJson(json.decode(frame.body!));
        _messageListener.forEach((element) => element(message));
      },
    );

    stompClient.subscribe(
      destination: '/user/$_userName/contact/confirmation/queue',
      callback: (frame) {
        print(json.decode(frame.body!));
      },
    );
    stompClient.subscribe(
      destination: '/user/$_userName/contact/request/queue',
      callback: (frame) {
        print('resquest recebida');
        var contactRecommendation =
            ContactRecommendation.fromJson(jsonDecode(frame.body!));
        _requestAddContact.forEach((element) => element(contactRecommendation));
      },
    );

    stompClient.subscribe(
      destination: '/user/$_userName/contact/reject/queue',
      callback: (frame) {
        print(json.decode(frame.body!));
      },
    );
  }

  void send(String message, String destination) {
    if (!isActive) {
      print('ative websocket para poder enviar');
    }
    stompClient.send(
      destination: '/app/send',
      body: jsonEncode(
        Message(
          _userName,
          destination,
          message,
        ),
      ),
    );
  }

  void deactivate() {
    if (!isActive) {
      print('já está desativado');
    }
    stompClient.deactivate();
  }

  void requestAddContact(ContactRecommendation recommendation) {
    RequestAddContact rad = RequestAddContact(
      from: _userName,
      to: recommendation.userName,
    );

    stompClient.send(
      destination: '/app/contact/request',
      body: jsonEncode(rad),
    );
  }

  void acceptContact(ContactRecommendation recommendation) {
    RequestAddContact rad = RequestAddContact(
      from: _userName,
      to: recommendation.userName,
    );

    stompClient.send(
      destination: '/app/contact/confirmation',
      body: jsonEncode(rad),
    );
  }

  void rejectContact(ContactRecommendation recommendation) {
    RequestAddContact rad = RequestAddContact(
      from: _userName,
      to: recommendation.userName,
    );

    stompClient.send(
      destination: '/app/contact/reject',
      body: jsonEncode(rad),
    );
  }

  addRequestAddContactListener(
      Function(ContactRecommendation contactRecommendation) func) {
    _requestAddContact.add(func);
  }

  removeRequestAddContactListener(
      Function(ContactRecommendation contactRecommendation) func) {
    _requestAddContact.remove(func);
  }

  addMessageListener(Function(Message) listener) {
    _messageListener.add(listener);
  }

  removeMessageListener(Function(Message) listener) {
    _messageListener.remove(listener);
  }
}
