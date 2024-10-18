class DistanceMatrixRes {
  final List<String>? destinationAddresses;
  final List<String>? originAddresses;
  final List<Row> rows;
  final String? status;

  DistanceMatrixRes({
    this.destinationAddresses,
    this.originAddresses,
    this.rows = const [],
    this.status,
  });

  String? get estimatedTime {
    if (rows.isEmpty) return null;

    final row = rows.first;
    if (row.elements.isEmpty) return null;

    final element = row.elements.first;
    return element.duration?.text;
  }

  DistanceMatrixRes copyWith({
    List<String>? destinationAddresses,
    List<String>? originAddresses,
    List<Row>? rows,
    String? status,
  }) {
    return DistanceMatrixRes(
      destinationAddresses: destinationAddresses ?? this.destinationAddresses,
      originAddresses: originAddresses ?? this.originAddresses,
      rows: rows ?? this.rows,
      status: status ?? this.status,
    );
  }

  factory DistanceMatrixRes.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixRes(
      destinationAddresses:
          json['destination_addresses'] == null ? [] : List<String>.from(json['destination_addresses']!.map((x) => x)),
      originAddresses:
          json['origin_addresses'] == null ? [] : List<String>.from(json['origin_addresses']!.map((x) => x)),
      rows: json['rows'] == null ? [] : List<Row>.from(json['rows']!.map((x) => Row.fromJson(x))),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination_addresses':
          destinationAddresses == null ? [] : List<dynamic>.from(destinationAddresses!.map((x) => x)),
      'origin_addresses': originAddresses == null ? [] : List<dynamic>.from(originAddresses!.map((x) => x)),
      'rows': List<dynamic>.from(rows.map((x) => x.toJson())),
      'status': status,
    };
  }
}

class Row {
  final List<Element> elements;

  Row({this.elements = const []});

  Row copyWith({
    List<Element>? elements,
  }) {
    return Row(
      elements: elements ?? this.elements,
    );
  }

  factory Row.fromJson(Map<String, dynamic> json) {
    return Row(
      elements: json['elements'] == null ? [] : List<Element>.from(json['elements']!.map((x) => Element.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elements': List<dynamic>.from(elements.map((x) => x.toJson())),
    };
  }
}

class Element {
  final Distance? distance;
  final Distance? duration;
  final String? status;

  Element({
    this.distance,
    this.duration,
    this.status,
  });

  Element copyWith({
    Distance? distance,
    Distance? duration,
    String? status,
  }) {
    return Element(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
      distance: json['distance'] == null ? null : Distance.fromJson(json['distance']),
      duration: json['duration'] == null ? null : Distance.fromJson(json['duration']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'status': status,
    };
  }
}

class Distance {
  final String? text;
  final int? value;

  Distance({
    this.text,
    this.value,
  });

  Distance copyWith({
    String? text,
    int? value,
  }) {
    return Distance(
      text: text ?? this.text,
      value: value ?? this.value,
    );
  }

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}
