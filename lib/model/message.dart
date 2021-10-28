import 'package:intl/intl.dart';

class Message {
  final int userId;
  final String userName;
  final String message;
  final bool isSend;
  final DateTime dateMessage;

  final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss SSS');
  final _dateFormatBR = DateFormat('dd-MM-yyyy HH:mm:ss');

  Message(
    this.userId,
    this.userName,
    this.message,
    this.isSend,
    this.dateMessage,
  );

  get _dateMessageFormattedDB => _dateFormat.format(dateMessage);
  get dateMessageFormattedBR => _dateFormatBR.format(dateMessage);

  Map<String, dynamic> toMap() {
    return {
      'USER_ID': userId,
      'USER_NAME': userName,
      'MESSAGE': message,
      'IS_SEND': isSend ? 1 : 0,
      'DATE_MESSAGE': _dateMessageFormattedDB,
    };
  }
}
