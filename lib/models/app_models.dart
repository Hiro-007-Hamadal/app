class AttendanceRecord {
  final String id;
  final String subjectName;
  int weeksPerMonth;
  int classesPerWeek;
  int present;
  int absent;

  AttendanceRecord({
    required this.id,
    required this.subjectName,
    this.weeksPerMonth = 4,
    this.classesPerWeek = 3,
    this.present = 0,
    this.absent = 0,
  });

  int get totalMonthlyClasses => weeksPerMonth * classesPerWeek;
  int get totalClassesSoFar => present + absent;

  double get percentage {
    if (totalClassesSoFar == 0) return 100.0;
    return (present / totalClassesSoFar) * 100;
  }

  bool get isEligible => percentage >= 75.0;
  int get maxAllowedAbsents => (totalMonthlyClasses * 0.25).floor();

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectName': subjectName,
    'weeksPerMonth': weeksPerMonth,
    'classesPerWeek': classesPerWeek,
    'present': present,
    'absent': absent,
  };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] ?? '',
      subjectName: map['subjectName'] ?? '',
      weeksPerMonth: map['weeksPerMonth'] ?? 4,
      classesPerWeek: map['classesPerWeek'] ?? 3,
      present: map['present'] ?? 0,
      absent: map['absent'] ?? 0,
    );
  }
}