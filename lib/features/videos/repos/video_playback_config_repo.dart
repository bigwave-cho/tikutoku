// 역할 : 데이털르 디스크에 persist
// flutter pub add shared_preferences
import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  static const String _autoPlay = "autoplay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoPlay, value);
  }

  bool isMuted() {
    // 디스크에 아무것도 저장돼있지 않는 상황 대비 ?? false
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoPlay) ?? false;
  }
}
