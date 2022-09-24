import 'package:the_sun_exchange_unofficial/model/dashboard_totals.dart';
import 'package:the_sun_exchange_unofficial/model/project_dashboard.dart';

class Dashboard {
  final List<ProjectDashboard> projects;
  final List<DashboardTotals> totals;

  Dashboard({required this.projects, required this.totals});

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    List list = json['projects'] ?? [];
    final List<ProjectDashboard> projects =
        list.map((e) => ProjectDashboard.fromJson(e)).toList();
    final List<DashboardTotals> totals = (json['totals'] as List)
        .map((e) => DashboardTotals.fromJson(e))
        .toList();

    return Dashboard(projects: projects, totals: totals);
  }
}
