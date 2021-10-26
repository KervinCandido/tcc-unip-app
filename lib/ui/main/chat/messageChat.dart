class MessageChat {
  final String text;
  final MessageType type;

  MessageChat(this.text, this.type);

  @override
  String toString() {
    return 'type: $type, text: $text';
  }
}

enum MessageType {
  SEND,
  RECEIVER,
}
