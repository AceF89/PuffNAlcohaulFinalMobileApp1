class Pagination<T> {
  final num totalData;
  final num totalPages;
  final T? data;

  Pagination({
    this.totalData = 0,
    this.totalPages = 0,
    this.data,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalData: json['totalData'],
      totalPages: json['totalPages'],
      data: json['data'],
    );
  }
}
