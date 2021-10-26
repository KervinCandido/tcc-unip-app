import 'package:app_tcc_unip/model/sortSpring.dart';

class PageableSpring {
  SortSpring sortSpring;
  int pageNumber;
  int pageSize;
  int offset;
  bool unpaged;
  bool paged;

  PageableSpring({
    required this.sortSpring,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.unpaged,
    required this.paged,
  });

  factory PageableSpring.fromJson(Map<String, dynamic> json) {
    return PageableSpring(
      sortSpring: SortSpring.fromJson(json['sort']),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      offset: json['offset'],
      unpaged: json['unpaged'],
      paged: json['paged'],
    );
  }
}
