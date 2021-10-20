class Message {
  final String text;
  final MessageType type;

  Message(this.text, this.type);

  @override
  String toString() {
    return 'type: $type, text: $text';
  }
}

enum MessageType {
  SEND,
  RECEIVER,
}
