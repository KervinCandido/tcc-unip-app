class Message {
  final String sender;
  final String receiver;
  final String content;

  Message(this.sender, this.receiver, this.content);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['sender'],
      json['receiver'],
      json['content'],
    );
  }

  Map toJson() {
    return {
      "sender": sender,
      "receiver": receiver,
      "content": content,
    };
  }
}
