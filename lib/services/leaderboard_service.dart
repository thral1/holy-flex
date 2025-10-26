import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leaderboard_entry.dart';
import '../models/game_session.dart';

class LeaderboardService {
  static const String _leaderboardKey = 'leaderboard_entries';
  static const int _maxEntries = 100;

  Future<void> saveScore(GameSession session, String username) async {
    final prefs = await SharedPreferences.getInstance();

    final entry = LeaderboardEntry(
      userId: session.userId,
      username: username,
      score: session.totalScore,
      levelId: session.levelId,
      completedAt: session.endTime ?? DateTime.now(),
    );

    final allEntries = await _readAllEntries();
    allEntries.add(entry);

    final grouped = <String, List<LeaderboardEntry>>{};
    for (final e in allEntries) {
      grouped.putIfAbsent(e.levelId, () => []).add(e);
    }

    final trimmedEntries = <LeaderboardEntry>[];
    for (final levelEntries in grouped.values) {
      levelEntries.sort((a, b) => b.score.compareTo(a.score));
      trimmedEntries.addAll(levelEntries.take(_maxEntries));
    }

    final jsonList = trimmedEntries.map((e) => e.toJson()).toList();
    await prefs.setString(_leaderboardKey, json.encode(jsonList));
  }

  Future<List<LeaderboardEntry>> getLeaderboard(String levelId) async {
    final allEntries = await _readAllEntries();
    final levelEntries =
        allEntries.where((entry) => entry.levelId == levelId).toList()
          ..sort((a, b) => b.score.compareTo(a.score));
    return levelEntries;
  }

  Future<int?> getUserRank(String userId, String levelId) async {
    final entries = await getLeaderboard(levelId);

    for (int i = 0; i < entries.length; i++) {
      if (entries[i].userId == userId) {
        return i + 1; // 1-indexed rank
      }
    }

    return null;
  }

  Future<void> clearLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_leaderboardKey);
  }

  Future<List<LeaderboardEntry>> getAllEntries() async {
    final entries = await _readAllEntries();
    entries.sort((a, b) => b.score.compareTo(a.score));
    return entries;
  }

  Future<List<LeaderboardEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_leaderboardKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
