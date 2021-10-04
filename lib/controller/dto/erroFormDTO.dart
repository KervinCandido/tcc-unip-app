class ErroFormDTO {
  final String field;
  final String message;

  ErroFormDTO({required this.field, required this.message});

  factory ErroFormDTO.fromJson(Map<String, dynamic> json) {
    return ErroFormDTO(
      field: json['field'],
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'field: $field, message: $message';
  }
}
