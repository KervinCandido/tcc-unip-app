class TokenDTO {
  final String type;
  final String token;

  TokenDTO({required this.type, required this.token});

  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(
      type: json['type'],
      token: json['token'],
    );
  }

  @override
  String toString() => "{type: $type, token: $token}";
}
