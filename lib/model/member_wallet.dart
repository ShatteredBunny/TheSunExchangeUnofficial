class MemberWallet {
  final int id;
  final int memberId;
  final String? address;
  final String currency;
  final double balance;

  MemberWallet({
    required this.id,
    required this.memberId,
    required this.address,
    required this.currency,
    required this.balance,
  });

  factory MemberWallet.fromJson(Map<String, dynamic> json) {
    return MemberWallet(
        id: json['id'],
        memberId: json['memberId'],
        address: json['address'],
        currency: json['currency'],
        balance: json['balance'] is int
            ? (json['balance'] as int).toDouble()
            : json['balance']);
  }
}
