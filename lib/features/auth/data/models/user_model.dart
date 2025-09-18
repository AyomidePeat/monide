class UserModel {
 final String uid;
 final String name;
 final String email;
 final String phoneNumber;

 UserModel({
 required this.uid,
 required this.name,
 required this.email,
 required this.phoneNumber,
 });

 Map<String, dynamic> toJson() {
 return {
 'name': name,
 'email': email,
 'phoneNumber': phoneNumber,
 };
 }

 factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
 return UserModel(
 uid: uid,
 name: json['name'] ?? '',
 email: json['email'] ?? '',
 phoneNumber: json['phoneNumber'] ?? '',
 );
 }
}