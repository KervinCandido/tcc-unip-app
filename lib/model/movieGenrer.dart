class MovieGenrer {
  final int id;
  final String name;

  MovieGenrer({required this.id, required this.name});

  factory MovieGenrer.fromJson(Map<String, dynamic> json) {
    return MovieGenrer(
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
      'MOVIE_ID': id,
      'NAME': name,
    };
  }
}
