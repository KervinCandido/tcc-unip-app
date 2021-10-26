class SortSpring {
  bool sorted;
  bool unsorted;
  bool empty;

  SortSpring({
    required this.sorted,
    required this.unsorted,
    required this.empty,
  });

  factory SortSpring.fromJson(Map<String, dynamic> json) {
    return new SortSpring(
      sorted: json['sorted'],
      unsorted: json['unsorted'],
      empty: json['empty'],
    );
  }
}
