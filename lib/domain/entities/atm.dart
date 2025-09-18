class ATM {
  final String name;
  final double distance;
  final String address;
  final String city;
  final String imageUrl;

  ATM({
    required this.name,
    required this.distance,
    required this.address,
    required this.city,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'distance': distance,
        'address': address,
        'city': city,
        'imageUrl': imageUrl,
      };

  factory ATM.fromJson(Map<String, dynamic> json) {
    return ATM(
      name: json['name'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      address: json['address']?['road'] as String? ?? '',
      city: json['address']?['city'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
