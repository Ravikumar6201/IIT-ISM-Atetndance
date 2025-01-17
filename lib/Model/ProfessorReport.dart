class DatewiseReport {
  dynamic id;
  dynamic classPeriods;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic engagedBy;
  dynamic date;
  dynamic timestamp;

  DatewiseReport(
      {this.id,
      this.classPeriods,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.engagedBy,
      this.date,
      this.timestamp});

  DatewiseReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classPeriods = json['class_periods'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['class_periods'] = classPeriods;
    data['session'] = session;
    data['session_year'] = sessionYear;
    data['sub_offered_id'] = subOfferedId;
    data['course_code'] = courseCode;
    data['engaged_by'] = engagedBy;
    data['date'] = date;
    data['timestamp'] = timestamp;
    return data;
  }
}
