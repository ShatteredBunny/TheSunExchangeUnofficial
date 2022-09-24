class ProjectEarnings {
  final double rentalEarned;
  final String currency;

  ProjectEarnings({
    required this.currency,
    required this.rentalEarned,
  });

  factory ProjectEarnings.fromJson(Map<String, dynamic> json) {
    return ProjectEarnings(
      rentalEarned: json['rentalEarned'],
      currency: json['currency'],
    );
  }
}
