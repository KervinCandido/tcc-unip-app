class MusicalGenrer {
  final int id;
  final String name;

  MusicalGenrer({required this.id, required this.name});

  factory MusicalGenrer.fromJson(Map<String, dynamic> json) {
    return MusicalGenrer(
      id: json['id'],
      name: json['name'],
    );
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'MUSICAL_ID': id,
      'NAME': name,
    };
  }
}
