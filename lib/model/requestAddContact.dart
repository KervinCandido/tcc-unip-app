class RequestAddContact {
  String from;
  String to;

  RequestAddContact({
    required this.from,
    required this.to,
  });

  Map toJson() {
    return {
      "from": this.from,
      "to": this.to,
    };
  }
}
