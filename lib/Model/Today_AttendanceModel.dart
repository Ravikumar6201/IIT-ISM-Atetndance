// // ignore_for_file: unnecessary_this

// ignore_for_file: unnecessary_this

class AllStudentAttendanceList {
  dynamic id;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic engagedBy;
  dynamic date;
  dynamic groupNo;
  dynamic classNo;
  dynamic totalClass;
  dynamic section;
  dynamic timestamp;
  dynamic admnNo;
  dynamic status;
  dynamic markAttendance;
  dynamic classRedius;
  dynamic classOtp;
  dynamic latitude;
  dynamic logitude;
  dynamic classOtpTime;
  dynamic classCheck;
  dynamic remark2;
  dynamic createdAt;
  dynamic updatedAt;

  AllStudentAttendanceList(
      {this.id,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.engagedBy,
      this.date,
      this.groupNo,
      this.classNo,
      this.totalClass,
      this.section,
      this.timestamp,
      this.admnNo,
      this.status,
      this.markAttendance,
      this.classRedius,
      this.classOtp,
      this.latitude,
      this.logitude,
      this.classOtpTime,
      this.classCheck,
      this.remark2,
      this.createdAt,
      this.updatedAt});

  AllStudentAttendanceList.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    groupNo = json['group_no'];
    classNo = json['class_no'];
    totalClass = json['total_class'];
    section = json['section'];
    timestamp = json['timestamp'];
    admnNo = json['admn_no'];
    status = json['status'];
    markAttendance = json['mark_attendance'];
    classRedius = json['class_redius'];
    classOtp = json['class_otp'];
    latitude = json['latitude'];
    logitude = json['logitude'];
    classOtpTime = json['class_otp_time'];
    classCheck = json['class_check'];
    remark2 = json['remark2'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['session'] = this.session;
    data['session_year'] = this.sessionYear;
    data['sub_offered_id'] = this.subOfferedId;
    data['course_code'] = this.courseCode;
    data['engaged_by'] = this.engagedBy;
    data['date'] = this.date;
    data['group_no'] = this.groupNo;
    data['class_no'] = this.classNo;
    data['total_class'] = this.totalClass;
    data['section'] = this.section;
    data['timestamp'] = this.timestamp;
    data['admn_no'] = this.admnNo;
    data['status'] = this.status;
    data['mark_attendance'] = this.markAttendance;
    data['class_redius'] = this.classRedius;
    data['class_otp'] = this.classOtp;
    data['latitude'] = this.latitude;
    data['logitude'] = this.logitude;
    data['class_otp_time'] = this.classOtpTime;
    data['class_check'] = this.classCheck;
    data['remark2'] = this.remark2;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// // class StudentAttendance {
// //   StudentAttendance({
// //     required this.status,
// //     required this.admnNo,
// //     required this.remark2,
// //     required this.section,
// //     required this.latitude,
// //     required this.longitude,
// //     required this.timestamp,
// //     required this.totalClassPresent,
// //     required this.classPeriods,
// //   });

// //   dynamic status;
// //   dynamic admnNo;
// //   dynamic remark2;
// //   dynamic section;
// //   dynamic latitude;
// //   dynamic longitude;
// //   DateTime timestamp;
// //   dynamic totalClassPresent;
// //   dynamic classPeriods;

// //   factory StudentAttendance.fromJson(Map<dynamic, dynamic> json) {
// //     return StudentAttendance(
// //       status: json['status'] as dynamic,
// //       admnNo: json['admn_no'] as dynamic,
// //       remark2: json['remark2'] as dynamic,
// //       section: json['section'] as dynamic,
// //       latitude: json['latitude'] as dynamic,
// //       longitude: json['longitude'] as dynamic, // Corrected typo here
// //       timestamp: DateTime.parse(json['timestamp'] as dynamic), // Corrected date parsing
// //       totalClassPresent: json['total_class_present'] as dynamic,
// //       classPeriods: json['class_periods'] as dynamic, // Assuming 'class_periods' exists in your JSON
// //     );
// //   }
// // }

// class AttendanceList {
//   dynamic classDate;
//   dynamic classPeriods;
//   dynamic id;
//   dynamic session;
//   dynamic sessionYear;
//   dynamic subOfferedId;
//   dynamic courseCode;
//   dynamic section;
//   dynamic engagedBy;
//   dynamic date;
//   dynamic classRedius;
//   dynamic classOtp;
//   dynamic latitudeData;
//   dynamic logitudeData;
//   dynamic classOtpTimeData;
//   List<StudentAttendance>? studentAttendance;

//   AttendanceList(
//       {this.classDate,
//       this.classPeriods,
//       this.id,
//       this.session,
//       this.sessionYear,
//       this.subOfferedId,
//       this.courseCode,
//       this.section,
//       this.engagedBy,
//       this.date,
//       this.classRedius,
//       this.classOtp,
//       this.latitudeData,
//       this.logitudeData,
//       this.classOtpTimeData,
//       this.studentAttendance});

//   AttendanceList.fromJson(Map<String, dynamic> json) {
//     classDate = json['class_date'];
//     classPeriods = json['class_periods'];
//     id = json['id'];
//     session = json['session'];
//     sessionYear = json['session_year'];
//     subOfferedId = json['sub_offered_id'];
//     courseCode = json['course_code'];
//     section = json['section'];
//     engagedBy = json['engaged_by'];
//     date = json['date'];
//     classRedius = json['class_redius'];
//     classOtp = json['class_otp'];
//     latitudeData = json['latitude_data'];
//     logitudeData = json['logitude_data'];
//     classOtpTimeData = json['class_otp_time_data'];
//     if (json['student_attendance'] != null) {
//       studentAttendance = <StudentAttendance>[];
//       json['student_attendance'].forEach((v) {
//         studentAttendance!.add(new StudentAttendance.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['class_date'] = this.classDate;
//     data['class_periods'] = this.classPeriods;
//     data['id'] = this.id;
//     data['session'] = this.session;
//     data['session_year'] = this.sessionYear;
//     data['sub_offered_id'] = this.subOfferedId;
//     data['course_code'] = this.courseCode;
//     data['section'] = this.section;
//     data['engaged_by'] = this.engagedBy;
//     data['date'] = this.date;
//     data['class_redius'] = this.classRedius;
//     data['class_otp'] = this.classOtp;
//     data['latitude_data'] = this.latitudeData;
//     data['logitude_data'] = this.logitudeData;
//     data['class_otp_time_data'] = this.classOtpTimeData;
//     if (this.studentAttendance != null) {
//       data['student_attendance'] =
//           this.studentAttendance!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class StudentAttendance {
//   dynamic admnNo;
//   dynamic studentId;
//   dynamic status;
//   dynamic remark2;

//   StudentAttendance({this.admnNo, this.studentId, this.status, this.remark2});

//   StudentAttendance.fromJson(Map<String, dynamic> json) {
//     admnNo = json['admn_no'];
//     studentId = json['student_id'];
//     status = json['status'];
//     remark2 = json['remark2'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['admn_no'] = this.admnNo;
//     data['student_id'] = this.studentId;
//     data['status'] = this.status;
//     data['remark2'] = this.remark2;
//     return data;
//   }
// }

// class Autogenerated {
//   dynamic status;
//   AttendanceList? attendanceList;

//   Autogenerated({this.status, this.attendanceList});

//   Autogenerated.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     attendanceList = json['attendance_list'] != null
//         ? new AttendanceList.fromJson(json['attendance_list'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.attendanceList != null) {
//       data['attendance_list'] = this.attendanceList!.toJson();
//     }
//     return data;
//   }
// }

class AttendanceList {
  dynamic classDate;
  dynamic classPeriods;
  dynamic id;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic section;
  dynamic engagedBy;
  dynamic date;
  dynamic classRedius;
  dynamic classOtp;
  dynamic latitudeData;
  dynamic logitudeData;
  dynamic classOtpTimeData;
  List<StudentAttendance>? studentAttendance;

  AttendanceList(
      {this.classDate,
      this.classPeriods,
      this.id,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.section,
      this.engagedBy,
      this.date,
      this.classRedius,
      this.classOtp,
      this.latitudeData,
      this.logitudeData,
      this.classOtpTimeData,
      this.studentAttendance});

  AttendanceList.fromJson(Map<String, dynamic> json) {
    classDate = json['class_date'];
    classPeriods = json['class_periods'];
    id = json['id'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    section = json['section'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    classRedius = json['class_redius'];
    classOtp = json['class_otp'];
    latitudeData = json['latitude_data'];
    logitudeData = json['logitude_data'];
    classOtpTimeData = json['class_otp_time_data'];
    if (json['student_attendance'] != null) {
      studentAttendance = <StudentAttendance>[];
      json['student_attendance'].forEach((v) {
        studentAttendance!.add(StudentAttendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['class_date'] = this.classDate;
    data['class_periods'] = this.classPeriods;
    data['id'] = this.id;
    data['session'] = this.session;
    data['session_year'] = this.sessionYear;
    data['sub_offered_id'] = this.subOfferedId;
    data['course_code'] = this.courseCode;
    data['section'] = this.section;
    data['engaged_by'] = this.engagedBy;
    data['date'] = this.date;
    data['class_redius'] = this.classRedius;
    data['class_otp'] = this.classOtp;
    data['latitude_data'] = this.latitudeData;
    data['logitude_data'] = this.logitudeData;
    data['class_otp_time_data'] = this.classOtpTimeData;
    if (this.studentAttendance != null) {
      data['student_attendance'] =
          this.studentAttendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<void> fromMap(Map<String, dynamic> map) async {}
}

class StudentAttendance {
  dynamic classDate;
  dynamic admnNo;
  dynamic studentId;
  dynamic status;
  dynamic classPeriods;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic section;
  dynamic engagedBy;
  dynamic date;
  dynamic classRedius;
  dynamic classOtp;
  dynamic latitudeData;
  dynamic logitudeData;
  dynamic remark2;
  dynamic classOtpTimeData;
  dynamic image;
  dynamic stu_name;

  StudentAttendance(
      {this.classDate,
      this.admnNo,
      this.studentId,
      this.status,
      this.classPeriods,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.section,
      this.engagedBy,
      this.date,
      this.classRedius,
      this.classOtp,
      this.latitudeData,
      this.logitudeData,
      this.remark2,
      this.classOtpTimeData,
      this.image,
      this.stu_name});

  StudentAttendance.fromJson(Map<String, dynamic> json) {
    classDate = json['class_date'];
    admnNo = json['admn_no'];
    studentId = json['student_id'];
    status = json['status'];
    classPeriods = json['class_periods'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    section = json['section'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    classRedius = json['class_redius'];
    classOtp = json['class_otp'];
    latitudeData = json['latitude_data'];
    logitudeData = json['logitude_data'];
    remark2 = json['remark2'];
    classOtpTimeData = json['class_otp_time_data'];
    image = json['image'];
    stu_name = json['stu_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['class_date'] = this.classDate;
    data['admn_no'] = this.admnNo;
    data['student_id'] = this.studentId;
    data['status'] = this.status;
    data['class_periods'] = this.classPeriods;
    data['session'] = this.session;
    data['session_year'] = this.sessionYear;
    data['sub_offered_id'] = this.subOfferedId;
    data['course_code'] = this.courseCode;
    data['section'] = this.section;
    data['engaged_by'] = this.engagedBy;
    data['date'] = this.date;
    data['class_redius'] = this.classRedius;
    data['class_otp'] = this.classOtp;
    data['latitude_data'] = this.latitudeData;
    data['logitude_data'] = this.logitudeData;
    data['remark2'] = this.remark2;
    data['class_otp_time_data'] = this.classOtpTimeData;
    data['image'] = this.image;
    data['stu_name'] = this.stu_name;
    return data;
  }
}

class AllOptions {
  dynamic id;
  dynamic name;

  AllOptions({
    this.id,
    this.name,
  });

  AllOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    return data;
  }
}
//pending

class PendingListModel {
  dynamic classPeriods;
  dynamic id;
  dynamic session;
  dynamic sessionYear;
  dynamic subOfferedId;
  dynamic courseCode;
  dynamic section;
  dynamic engagedBy;
  dynamic date;
  dynamic classRadius;
  dynamic classOtp;
  dynamic latitude;
  dynamic longitude;
  dynamic remark2;
  dynamic classOtpTime;
  dynamic sub_name;

  PendingListModel(
      {this.classPeriods,
      this.id,
      this.session,
      this.sessionYear,
      this.subOfferedId,
      this.courseCode,
      this.section,
      this.engagedBy,
      this.date,
      this.classRadius,
      this.classOtp,
      this.latitude,
      this.longitude,
      this.remark2,
      this.classOtpTime,
      this.sub_name});

  PendingListModel.fromJson(Map<String, dynamic> json) {
    classPeriods = json['class_periods'];
    id = json['id'];
    session = json['session'];
    sessionYear = json['session_year'];
    subOfferedId = json['sub_offered_id'];
    courseCode = json['course_code'];
    section = json['section'];
    engagedBy = json['engaged_by'];
    date = json['date'];
    classRadius = json['class_radius'];
    classOtp = json['class_otp'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    remark2 = json['remark2'];
    classOtpTime = json['class_otp_time'];
    sub_name = json['sub_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['class_periods'] = this.classPeriods;
    data['id'] = this.id;
    data['session'] = this.session;
    data['session_year'] = this.sessionYear;
    data['sub_offered_id'] = this.subOfferedId;
    data['course_code'] = this.courseCode;
    data['section'] = this.section;
    data['engaged_by'] = this.engagedBy;
    data['date'] = this.date;
    data['class_radius'] = this.classRadius;
    data['class_otp'] = this.classOtp;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['remark2'] = this.remark2;
    data['class_otp_time'] = this.classOtpTime;
    data['sub_name'] = this.sub_name;
    return data;
  }
}
