class DashboardTotals {
  final double totalEarnedToDate;
  final double outstandingBalance;
  final double totalUnprocessedPayments;
  final double totalEnergyGenerated;
  final double totalGenerationCapacity;
  final double totalPaid;
  final String currency;
  final String lastDistributionDate;

  DashboardTotals(
      {required this.totalEarnedToDate,
      required this.outstandingBalance,
      required this.totalUnprocessedPayments,
      required this.totalEnergyGenerated,
      required this.totalGenerationCapacity,
      required this.totalPaid,
      required this.currency,
      required this.lastDistributionDate});

  factory DashboardTotals.fromJson(Map<String, dynamic> json) {
    return DashboardTotals(
      totalEarnedToDate: json['totalEarnedToDate'] is int
          ? (json['totalEarnedToDate'] as int).toDouble()
          : json['totalEarnedToDate'] as double,
      outstandingBalance: json['outstandingBalance'] is int
          ? (json['outstandingBalance'] as int).toDouble()
          : json['outstandingBalance'] as double,
      totalUnprocessedPayments: json['totalUnprocessedPayments'] is int
          ? (json['totalUnprocessedPayments'] as int).toDouble()
          : json['totalUnprocessedPayments'] as double,
      totalEnergyGenerated: json['totalEnergyGenerated'] is int
          ? (json['totalEnergyGenerated'] as int).toDouble()
          : json['totalEnergyGenerated'] as double,
      totalGenerationCapacity: json['totalGenerationCapacity'] is int
          ? (json['totalGenerationCapacity'] as int).toDouble()
          : json['totalGenerationCapacity'] as double,
      totalPaid: json['totalPaid'] is int
          ? (json['totalPaid'] as int).toDouble()
          : json['totalPaid'] as double,
      currency: json['currency'],
      lastDistributionDate: json['lastDistributionDate'],
    );
  }
}
