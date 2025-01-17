class StuCourseData_TA {
  dynamic classDate;
  dynamic id;
  dynamic classPeriods;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic engagedBy;
  dynamic date;
  dynamic classRadius;
  dynamic classOtp;
  dynamic latitude;
  dynamic longitude;
  dynamic classOtpTime;
  dynamic sub_name;
  StudentAttendance? studentAttendance;

  StuCourseData_TA(
      {this.classDate,
      this.id,
      this.classPeriods,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.engagedBy,
      this.date,
      this.classRadius,
      this.classOtp,
      this.latitude,
      this.longitude,
      this.classOtpTime,
      this.studentAttendance,
      this.sub_name});

  StuCourseData_TA.fromJson(Map<String, dynamic> json) {
    classDate = json['class_date'];
    id = json['id'];
    classPeriods = json['class_periods'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    classRadius = json['class_radius'];
    classOtp = json['class_otp'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    classOtpTime = json['class_otp_time'];
    sub_name = json['sub_name'];
    studentAttendance = json['student_attendance'] != null
        ? StudentAttendance.fromJson(json['student_attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['class_date'] = classDate;
    data['id'] = id;
    data['class_periods'] = classPeriods;
    data['session'] = session;
    data['session_year'] = sessionYear;
    data['sub_offered_id'] = subOfferedId;
    data['course_code'] = courseCode;
    data['engaged_by'] = engagedBy;
    data['date'] = date;
    data['class_radius'] = classRadius;
    data['class_otp'] = classOtp;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['class_otp_time'] = classOtpTime;
    data['sub_name'] = sub_name;
    if (studentAttendance != null) {
      data['student_attendance'] = studentAttendance!.toJson();
    }
    return data;
  }
}

class StudentAttendance {
  dynamic status;
  dynamic timestamp;

  StudentAttendance({this.status, this.timestamp});

  StudentAttendance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['timestamp'] = timestamp;
    return data;
  }
}
