import 'dart:convert';

import 'package:app_tcc_unip/model/converterPage.dart';
import 'package:app_tcc_unip/model/pageableSpring.dart';
import 'package:app_tcc_unip/model/sortSpring.dart';

class PageSpring<T> {
  List<T> content;
  PageableSpring pageable;
  int totalElements;
  int totalPages;
  bool last;
  int size;
  int number;
  SortSpring sort;
  bool first;
  int numberOfElements;
  bool empty;

  PageSpring({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory PageSpring.fromJson(
      Map<String, dynamic> json, ConverterPage<T> converterPage) {
    // Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
    // List<ErroFormDTO> errosFormDTO =
    //     List<ErroFormDTO>.from(it.map((model) => ErroFormDTO.fromJson(model)));

    Iterable it = json['content'];

    return PageSpring(
      content: List<T>.from(it.map((e) => converterPage.convert(e))),
      pageable: PageableSpring.fromJson(json['pageable']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      last: json['last'],
      size: json['size'],
      number: json['number'],
      sort: SortSpring.fromJson(json['sort']),
      first: json['first'],
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }
}
