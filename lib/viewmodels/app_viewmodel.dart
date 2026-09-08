import 'package:flutter/foundation.dart';
import '../models/app_models.dart';

class AppViewModel extends ChangeNotifier {
  final List<AttendanceRecord> _attendances = [];

  List<AttendanceRecord> get attendances => _attendances;

  void addAttendanceSubject(String subjectName, int weeksPerMonth, int classesPerWeek) {
    final newRecord = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjectName: subjectName,
      weeksPerMonth: weeksPerMonth,
      classesPerWeek: classesPerWeek,
      present: 0,
      absent: 0,
    );
    _attendances.add(newRecord);
    notifyListeners();
  }

  void markPresent(String id) {
    final index = _attendances.indexWhere((element) => element.id == id);
    if (index != -1) {
      _attendances[index].present++;
      notifyListeners();
    }
  }

  void markAbsent(String id) {
    final index = _attendances.indexWhere((element) => element.id == id);
    if (index != -1) {
      _attendances[index].absent++;
      notifyListeners();
    }
  }

  void updateAttendanceCount(String id, int present, int absent) {
    final index = _attendances.indexWhere((element) => element.id == id);
    if (index != -1) {
      _attendances[index].present = present;
      _attendances[index].absent = absent;
      notifyListeners();
    }
  }

  void resetAttendance(String id) {
    final index = _attendances.indexWhere((element) => element.id == id);
    if (index != -1) {
      _attendances[index].present = 0;
      _attendances[index].absent = 0;
      notifyListeners();
    }
  }

  void deleteAttendanceSubject(String id) {
    _attendances.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}