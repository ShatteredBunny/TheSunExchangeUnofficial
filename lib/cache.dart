import 'package:the_sun_exchange_unofficial/model/member.dart';
import 'package:the_sun_exchange_unofficial/model/project.dart';

import 'api.dart';

class Cache {
  static final _instance = Cache();
  Map<String, Project>? _projects;
  Member? _member;

  loadProjects() async {
    if (_projects == null) {
      List<Project> projects = await Api.get().projects();
      _projects = {for (var e in projects) e.urlSlug: e};
    }
  }

  Future<Project?> getProject(String urlSlug) async {
    loadProjects();
    return _projects?[urlSlug];
  }

  Future<Member> getMember() async {
    _member ??= await Api.get().member();
    return _member!;
  }

  Future<int> getMemberId() async {
    return (await getMember()).id;
  }

  Project? getProjectSync(String urlSlug) {
    return _projects?[urlSlug];
  }

  static Cache get() {
    return _instance;
  }
}
