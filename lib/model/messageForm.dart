class MessageForm {
  final String sender;
  final String receiver;
  final String content;

  MessageForm(this.sender, this.receiver, this.content);

  factory MessageForm.fromJson(Map<String, dynamic> json) {
    return MessageForm(
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
