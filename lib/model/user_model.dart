class UserDetails{
  final String name;
  final String phoneNumber;
  UserDetails({
    required this.name,
    required this.phoneNumber, 
  });

  Map<String, dynamic> toJson() => {'name': name, 'phoneNumber': phoneNumber};

  factory UserDetails.getModelFromJson({required Map<String, dynamic> json}) {
    return UserDetails(name: json['name'], phoneNumber: json['phoneNumber']);
  }
}
