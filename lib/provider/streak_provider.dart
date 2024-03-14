import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  int _streakCount = 0;

  int get streakCount => _streakCount;

  StreakProvider() {
    _loadStreakCount();
  }

  Future<void> _loadStreakCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _streakCount = prefs.getInt('streakCount') ?? 0;
    notifyListeners();
  }

  Future<void> _saveStreakCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streakCount', count);
  }

  void updateStreak() {
    DateTime currentDate = DateTime.now();
    SharedPreferences.getInstance().then((prefs) {
      String? lastRecordedDate = prefs.getString('lastRecordedDate');
      print(lastRecordedDate);
      if (lastRecordedDate != null) {
        DateTime lastDate = DateTime.parse(lastRecordedDate);
        if (isConsecutiveDay(currentDate, lastDate)) {
          // Increment streak if skincare routine recorded consecutively
          _streakCount++;
        } else {
          // Reset streak if skincare routine not recorded consecutively
          _streakCount = 1; // Reset streak to 1 as skincare routine recorded today
        }
      } else {
        // If there is no last recorded date, start a new streak
        _streakCount = 1;
      }
      // Save current date as last recorded date
      prefs.setString('lastRecordedDate', currentDate.toIso8601String());
      _saveStreakCount(_streakCount);
      notifyListeners();
    });
  }

  bool isConsecutiveDay(DateTime currentDate, DateTime lastDate) {
    // Check if currentDate is one day ahead of lastDate
    return currentDate.year == lastDate.year &&
        currentDate.month == lastDate.month &&
        currentDate.day - lastDate.day == 1;
  }

}
