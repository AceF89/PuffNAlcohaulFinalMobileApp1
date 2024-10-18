class Places {
  final int? id;
  final String? name;

  Places({
    this.id,
    this.name,
  });

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
