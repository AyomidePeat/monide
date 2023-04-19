class AtmStatus {
  final String name;
  final String address;
  final String withdrawalStatus;
  final String transferStatus;
  final String queueStatus;
  final String airtimeStatus;
  final String uploadDate;

  AtmStatus(
      {required this.name,
      required this.address,
      required this.withdrawalStatus,
      required this.transferStatus,
      required this.queueStatus,
      required this.airtimeStatus,
      required this.uploadDate});

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'queueStatus': queueStatus,
        'withdrawalStatus': withdrawalStatus,
        'transferStatus': transferStatus,
        'airtimeStatus': airtimeStatus,
        'uploadDate': uploadDate
      };

  factory AtmStatus.getModelFromJson({required Map<String, dynamic> json}) {
    return AtmStatus(
        name: json['name'],
        address: json['address'],
        withdrawalStatus: json['withdrawalStatus'],
        transferStatus: json['transferStatus'],
        queueStatus: json['queueStatus'],
        airtimeStatus: json['airtimeStatus'],
        uploadDate: json['uploadDate']);
  }
}
