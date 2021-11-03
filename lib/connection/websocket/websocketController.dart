import 'dart:convert';

import 'package:app_tcc_unip/dao/messageDAO.dart';
import 'package:app_tcc_unip/model/confirmationRequest.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/message.dart';
import 'package:app_tcc_unip/model/messageForm.dart';
import 'package:app_tcc_unip/model/rejectRequest.dart';
import 'package:app_tcc_unip/model/requestAddContact.dart';
import 'package:app_tcc_unip/model/requestContact.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

const BASE_URL_API = 'BASE_URL_API';

class WebsocketController {
  static WebsocketController _instance = WebsocketController._();

  final List<Function(RequestContact contactRecommendation)>
      _requestAddContact = [];

  final List<Function(MessageForm message)> _messageListener = [];

  final String baseURL = dotenv.get(BASE_URL_API);
  final _tokenService = TokenService();
  final _userService = UserService();

  late StompClient stompClient;
  late String _userName;

  bool isActive = false;

  final _messageDAO = MessageDAO();

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
        var message = MessageForm.fromJson(json.decode(frame.body!));

        _userService
            .getUserId()
            .then((userId) => _messageDAO.insertOrUpdate(Message(
                  userId,
                  message.sender,
                  message.content,
                  false,
                  DateTime.now(),
                )));

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
        var requestContact = RequestContact.fromJson(jsonDecode(frame.body!));
        _trataUrlPhoto(requestContact.requester);
        _trataUrlPhoto(requestContact.requested);
        _requestAddContact.forEach((element) => element(requestContact));
      },
    );

    stompClient.subscribe(
      destination: '/user/$_userName/contact/reject/queue',
      callback: (frame) {
        print(json.decode(frame.body!));
      },
    );
  }

  void _trataUrlPhoto(ContactRecommendation contactRecommendation) {
    if (contactRecommendation.photoProfile != null) {
      contactRecommendation.photoProfile =
          '$baseURL${contactRecommendation.photoProfile}';
    }
  }

  void send(String message, String destination) {
    if (!isActive) {
      print('ative websocket para poder enviar');
    }
    _userService
        .getUserId()
        .then((userId) => _messageDAO.insertOrUpdate(Message(
              userId,
              destination,
              message,
              true,
              DateTime.now(),
            )));

    stompClient.send(
      destination: '/app/send',
      body: jsonEncode(
        MessageForm(
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

  void acceptContact(int idRequest, ContactRecommendation recommendation) {
    var confirm = ConfirmationRequest(
      idRequest,
      _userName,
      recommendation.userName,
    );

    stompClient.send(
      destination: '/app/contact/confirmation',
      body: jsonEncode(confirm),
    );
  }

  void rejectContact(int idRequest, ContactRecommendation recommendation) {
    var reject = RejectRequest(
      idRequest,
      _userName,
      recommendation.userName,
    );

    stompClient.send(
      destination: '/app/contact/reject',
      body: jsonEncode(reject),
    );
  }

  addRequestAddContactListener(void Function(RequestContact) func) {
    _requestAddContact.add(func);
  }

  removeRequestAddContactListener(void Function(RequestContact) func) {
    _requestAddContact.remove(func);
  }

  addMessageListener(Function(MessageForm) listener) {
    _messageListener.add(listener);
  }

  removeMessageListener(Function(MessageForm) listener) {
    _messageListener.remove(listener);
  }
}
