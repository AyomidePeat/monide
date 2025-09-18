class AtmStatus {
  final String name;
  final String address;
  final String withdrawalStatus;
  final String transferStatus;
  final String queueStatus;
  final String airtimeStatus;
  final String uploadDate;

  AtmStatus({
    required this.name,
    required this.address,
    required this.withdrawalStatus,
    required this.transferStatus,
    required this.queueStatus,
    required this.airtimeStatus,
    required this.uploadDate,
  });
}