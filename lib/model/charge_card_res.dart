// import 'package:timezone/timezone.dart' as tz;

class ChargeCardRes {
  final num? id;
  final num? total;
  final String? balanceTransactionId;
  final DateTime? placedOn;

  ChargeCardRes({
    this.id,
    this.total,
    this.balanceTransactionId,
    this.placedOn,
  });

  String get formatDate {
    if (placedOn == null) return '';
    final localDate = placedOn!.toLocal();

    String day = localDate.day.toString().padLeft(2, '0');
    String month = localDate.month.toString().padLeft(2, '0');
    String year = localDate.year.toString();

    return '$month/$day/$year';
  }

  String get formatTime {
    if (placedOn == null) return '';
    final localDate = placedOn!.toLocal();

    String hour = localDate.hour.toString().padLeft(2, '0');
    String minute = localDate.minute.toString().padLeft(2, '0');
    String period = localDate.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  String get formatTimeCentral {
    if (placedOn == null) return '';

    // final localDate = placedOn!.toLocal();
    // final localTimeZone = tz.getLocation('America/Chicago');
    // final centralDateTime = tz.TZDateTime.from(placedOn!, localTimeZone);

    String hour = placedOn!.hour.toString().padLeft(2, '0');
    String minute = placedOn!.minute.toString().padLeft(2, '0');
    String period = placedOn!.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  ChargeCardRes copyWith({
    num? id,
    num? total,
    String? balanceTransactionId,
    DateTime? placedOn,
  }) {
    return ChargeCardRes(
      id: id ?? this.id,
      total: total ?? this.total,
      balanceTransactionId: balanceTransactionId ?? this.balanceTransactionId,
      placedOn: placedOn ?? this.placedOn,
    );
  }

  factory ChargeCardRes.fromJson(Map<String, dynamic> json) {
    return ChargeCardRes(
      id: json['id'],
      total: json['total'],
      balanceTransactionId: json['refNo'],
      placedOn: json['placedOn'] == null ? null : DateTime.parse(json['placedOn']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'refNo': balanceTransactionId,
      'placedOn': placedOn?.toIso8601String(),
    };
  }
}
