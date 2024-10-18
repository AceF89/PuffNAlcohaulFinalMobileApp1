class GPlaces {
  final String? description;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final Geometry? geometry;

  GPlaces({
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.geometry,
  });

  GPlaces copyWith({
    String? description,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    Geometry? geometry,
  }) {
    return GPlaces(
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      reference: reference ?? this.reference,
      structuredFormatting: structuredFormatting ?? this.structuredFormatting,
      geometry: geometry ?? this.geometry,
    );
  }

  factory GPlaces.fromJson(Map<String, dynamic> json) {
    return GPlaces(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json["structured_formatting"] == null
          ? null
          : StructuredFormatting.fromJson(json["structured_formatting"]),
      geometry:
          json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting?.toJson(),
      'geometry': geometry?.toJson(),
    };
  }
}

class Geometry {
  final Location? location;

  Geometry({
    this.location,
  });

  Geometry copyWith({
    Location? location,
  }) =>
      Geometry(
        location: location ?? this.location,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
      };
}

class Location {
  final double? lat;
  final double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstring>? mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  StructuredFormatting copyWith({
    String? mainText,
    List<MatchedSubstring>? mainTextMatchedSubstrings,
    String? secondaryText,
  }) =>
      StructuredFormatting(
        mainText: mainText ?? this.mainText,
        mainTextMatchedSubstrings:
            mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
        secondaryText: secondaryText ?? this.secondaryText,
      );

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null
            ? []
            : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": mainTextMatchedSubstrings == null
            ? []
            : List<dynamic>.from(
                mainTextMatchedSubstrings!.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class MatchedSubstring {
  final int? length;
  final int? offset;

  MatchedSubstring({
    this.length,
    this.offset,
  });

  MatchedSubstring copyWith({
    int? length,
    int? offset,
  }) =>
      MatchedSubstring(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}
