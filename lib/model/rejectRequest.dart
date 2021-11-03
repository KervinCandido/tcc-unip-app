class RejectRequest {
  int requestId;
  String from;
  String to;

  RejectRequest(this.requestId, this.from, this.to);

  Map toJson() {
    return {
      "requestId": this.requestId,
      "from": this.from,
      "to": this.to,
    };
  }
}
