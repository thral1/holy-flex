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

    final entries = await getLeaderboard(session.levelId);
    entries.add(entry);

    // Sort by score descending
    entries.sort((a, b) => b.score.compareTo(a.score));

    // Keep only top entries
    final topEntries = entries.take(_maxEntries).toList();

    final jsonList = topEntries.map((e) => e.toJson()).toList();
    await prefs.setString(_leaderboardKey, json.encode(jsonList));
  }

  Future<List<LeaderboardEntry>> getLeaderboard(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_leaderboardKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final allEntries = jsonList
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      // Filter by level and sort
      final levelEntries = allEntries
          .where((entry) => entry.levelId == levelId)
          .toList();

      levelEntries.sort((a, b) => b.score.compareTo(a.score));
      return levelEntries;
    } catch (e) {
      return [];
    }
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
}
