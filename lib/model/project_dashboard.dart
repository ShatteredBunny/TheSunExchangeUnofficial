import 'package:the_sun_exchange_unofficial/model/project_earnings.dart';

class ProjectDashboard {
  final int id;
  final String displayName;
  final String name;
  final String urlSlug;
  final String status;
  final String? statusMessage;
  final String? startDate;
  final String? campaignEndDate;
  final int? costOfCellsOwned;
  final int? cellsOwned;
  // TODO:
  final List<ProjectEarnings> projectEarnings;
  final double? generatedKWhToDate;

  ProjectDashboard({
    required this.id,
    required this.displayName,
    required this.name,
    required this.urlSlug,
    required this.status,
    required this.statusMessage,
    required this.startDate,
    required this.campaignEndDate,
    required this.costOfCellsOwned,
    required this.cellsOwned,
    required this.projectEarnings,
    required this.generatedKWhToDate,
  });

  factory ProjectDashboard.fromJson(Map<String, dynamic> json) {
    final List<ProjectEarnings> projectEarnings =
        json['projectEarnings'] == null ? [] : (json['projectEarnings'] as List)
            .map((e) => ProjectEarnings.fromJson(e))
            .toList();

    return ProjectDashboard(
      id: json['projectId'] ?? json['id'],
      displayName: json['projectDisplayName'] ?? json['displayName'],
      name: json['projectName'] ?? json['name'],
      urlSlug: json['urlSlug'],
      status: json['projectStatus'],
      statusMessage: json['statusMessage'],
      startDate: json['projectStartDate'] ?? json['startDate'],
      campaignEndDate: json['campaignEndDate'],
      costOfCellsOwned: json['costOfCellsOwned'],
      cellsOwned: json['cellsOwned'],
      projectEarnings: projectEarnings,
      generatedKWhToDate: json['generatedKWhToDate'] is int
          ? (json['generatedKWhToDate'] as int).toDouble()
          : json['generatedKWhToDate'],
    );
  }
}
