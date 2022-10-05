import 'package:the_sun_exchange_unofficial/model/member.dart';
import 'package:the_sun_exchange_unofficial/model/project.dart';
import 'package:the_sun_exchange_unofficial/model/project_dashboard.dart';

import 'api.dart';

class TimedData<T> {
  T? _data;
  int _expires = 0;

  set(T data, int secondsValid) {
    _expires = DateTime.now().millisecondsSinceEpoch + secondsValid * 1000;
    _data = data;
  }

  T get() {
    return _data!;
  }

  bool valid() {
    return _expires >= DateTime.now().millisecondsSinceEpoch;
  }
}

class Cache {
  static final _instance = Cache();
  Map<String, Project>? _projects;
  List<ProjectDashboard>? _upcomingProjects;
  Member? _member;
  final TimedData<int> _btcToZar = TimedData();

  loadProjects() async {
    if (_projects == null) {
      List<Project> projects = await Api.get().projects();
      _projects = {for (var e in projects) e.urlSlug: e};
    }
  }

  loadUpcomingProjects() async {
    if (_projects == null) {
      _upcomingProjects = await Api.get().upcomingProjects();
    }
  }

  Future<Project?> getProject(String urlSlug) async {
    await loadProjects();
    return _projects?[urlSlug];
  }

  Future<List<ProjectDashboard>> getUpcomingProjects() async {
    await loadUpcomingProjects();
    return _upcomingProjects!;
  }

  Future<Member> getMember() async {
    _member ??= await Api.get().member();
    return _member!;
  }

  Future<int> getMemberId() async {
    return (await getMember()).id;
  }

  Future<int> getBtcToZar() async {
    if (!_btcToZar.valid()) {
      _btcToZar.set(await Api.get().btcToZar(), 60);
    }
    return _btcToZar.get();
  }

  Project? getProjectSync(String urlSlug) {
    return _projects?[urlSlug];
  }

  List<ProjectDashboard>? getUpcomingProjectsSync(
      {bool onlyComingSoon = true}) {
    if (_upcomingProjects == null) return null;
    if (onlyComingSoon) {
      return _upcomingProjects!
          .where((e) => e.status == "OPEN" || e.status.endsWith("COMING_SOON"))
          .toList();
    }
    return _upcomingProjects;
  }

  int getLastBtcToZarSync() {
    return _btcToZar.get();
  }

  static Cache get() {
    return _instance;
  }
}
