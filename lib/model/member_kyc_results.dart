class MemberKycResults {
  final String status;
  final String? provider;
  final String? tierLevel;
  final String? kycCheckDate;
  final String? displayStatus;
  final String? displayProvider;
  final String? displayTierLevel;
  final String? requiredMemberAction;
  final bool canCashOut;

  MemberKycResults({
    required this.status,
    required this.provider,
    required this.tierLevel,
    required this.kycCheckDate,
    required this.displayStatus,
    required this.displayProvider,
    required this.displayTierLevel,
    required this.requiredMemberAction,
    required this.canCashOut,
  });

  factory MemberKycResults.fromJson(Map<String, dynamic> json) {
    return MemberKycResults(
        status: json['status'],
        provider: json['provider'],
        tierLevel: json['tierLevel'],
        kycCheckDate: json['kycCheckDate'],
        displayStatus: json['displayStatus'],
        displayProvider: json['displayProvider'],
        displayTierLevel: json['displayTierLevel'],
        requiredMemberAction: json['requiredMemberAction'],
        canCashOut: json['canCashOut']);
  }
}
