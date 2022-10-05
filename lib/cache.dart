import 'package:the_sun_exchange_unofficial/model/member.dart';
import 'package:the_sun_exchange_unofficial/model/project.dart';

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
  Member? _member;
  final TimedData<int> _btcToZar = TimedData();

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

  Future<int> getBtcToZar() async {
    if (!_btcToZar.valid()) {
      _btcToZar.set(await Api.get().btcToZar(), 60);
    }
    return _btcToZar.get();
  }

  Project? getProjectSync(String urlSlug) {
    return _projects?[urlSlug];
  }

  int getLastBtcToZarSync() {
    return _btcToZar.get();
  }

  static Cache get() {
    return _instance;
  }
}
