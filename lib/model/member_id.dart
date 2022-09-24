class MemberId {
  final int memberId;

  MemberId({required this.memberId});

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
    };
  }
}
