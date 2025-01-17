// ignore_for_file: unnecessary_this, unnecessary_new

class Ssesion {
  dynamic id;
  dynamic session;
  dynamic active;
  dynamic fellowshipActive;
  dynamic tmsActive;
  dynamic leaveActive;

  Ssesion(
      {this.id,
      this.session,
      this.active,
      this.fellowshipActive,
      this.tmsActive,
      this.leaveActive});

  Ssesion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    session = json['session'];
    active = json['active'];
    fellowshipActive = json['fellowship_active'];
    tmsActive = json['tms_active'];
    leaveActive = json['leave_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['session'] = this.session;
    data['active'] = this.active;
    data['fellowship_active'] = this.fellowshipActive;
    data['tms_active'] = this.tmsActive;
    data['leave_active'] = this.leaveActive;
    return data;
  }
}

class SessionYear {
  dynamic id;
  dynamic sessionYear;
  dynamic active;
  dynamic fellowshipActive;
  dynamic leaveActive;
  dynamic tmsActive;

  SessionYear(
      {this.id,
      this.sessionYear,
      this.active,
      this.fellowshipActive,
      this.leaveActive,
      this.tmsActive});

  SessionYear.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionYear = json['session_year'];
    active = json['active'];
    fellowshipActive = json['fellowship_active'];
    leaveActive = json['leave_active'];
    tmsActive = json['tms_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['session_year'] = this.sessionYear;
    data['active'] = this.active;
    data['fellowship_active'] = this.fellowshipActive;
    data['leave_active'] = this.leaveActive;
    data['tms_active'] = this.tmsActive;
    return data;
  }
}

class Tadata {
  dynamic id;
  dynamic sessionYear;
  dynamic session;
  dynamic subCode;
  dynamic subOfferedId;
  dynamic ftId;
  dynamic admnNo;
  dynamic remark;
  dynamic status;
  dynamic createdAt;
  dynamic modifiedAt;

  Tadata(
      {this.id,
      this.sessionYear,
      this.session,
      this.subCode,
      this.subOfferedId,
      this.ftId,
      this.admnNo,
      this.remark,
      this.status,
      this.createdAt,
      this.modifiedAt});

  Tadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionYear = json['session_year'];
    session = json['session'];
    subCode = json['sub_code'];
    subOfferedId = json['sub_offered_id'];
    ftId = json['ft_id'];
    admnNo = json['admn_no'];
    remark = json['remark'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['session_year'] = this.sessionYear;
    data['session'] = this.session;
    data['sub_code'] = this.subCode;
    data['sub_offered_id'] = this.subOfferedId;
    data['ft_id'] = this.ftId;
    data['admn_no'] = this.admnNo;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    return data;
  }
}

class UserOtherDetails {
  dynamic id;
  dynamic religion;
  dynamic nationality;
  dynamic kashmiriImmigrant;
  dynamic hobbies;
  dynamic favPastTime;
  dynamic birthPlace;
  dynamic mobileNo;
  dynamic fatherName;
  dynamic motherName;
  dynamic empAllergy;
  dynamic empDisease;
  dynamic bankName;
  dynamic bankAccno;
  dynamic ifscCode;
  dynamic deviceId;
  dynamic deviceInfo;
  dynamic updatedAt;

  UserOtherDetails(
      {this.id,
      this.religion,
      this.nationality,
      this.kashmiriImmigrant,
      this.hobbies,
      this.favPastTime,
      this.birthPlace,
      this.mobileNo,
      this.fatherName,
      this.motherName,
      this.empAllergy,
      this.empDisease,
      this.bankName,
      this.bankAccno,
      this.ifscCode,
      this.deviceId,
      this.deviceInfo,
      this.updatedAt});

  UserOtherDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religion = json['religion'];
    nationality = json['nationality'];
    kashmiriImmigrant = json['kashmiri_immigrant'];
    hobbies = json['hobbies'];
    favPastTime = json['fav_past_time'];
    birthPlace = json['birth_place'];
    mobileNo = json['mobile_no'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    empAllergy = json['emp_allergy'];
    empDisease = json['emp_disease'];
    bankName = json['bank_name'];
    bankAccno = json['bank_accno'];
    ifscCode = json['ifsc_code'];
    deviceId = json['device_id'];
    deviceInfo = json['device_info'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['religion'] = this.religion;
    data['nationality'] = this.nationality;
    data['kashmiri_immigrant'] = this.kashmiriImmigrant;
    data['hobbies'] = this.hobbies;
    data['fav_past_time'] = this.favPastTime;
    data['birth_place'] = this.birthPlace;
    data['mobile_no'] = this.mobileNo;
    data['father_name'] = this.fatherName;
    data['mother_name'] = this.motherName;
    data['emp_allergy'] = this.empAllergy;
    data['emp_disease'] = this.empDisease;
    data['bank_name'] = this.bankName;
    data['bank_accno'] = this.bankAccno;
    data['ifsc_code'] = this.ifscCode;
    data['device_id'] = this.deviceId;
    data['device_info'] = this.deviceInfo;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  dynamic id;
  dynamic password;
  dynamic ciPassword;
  dynamic authId;
  dynamic createdDate;
  dynamic updatedDate;
  dynamic userHash;
  dynamic failedAttemptCnt;
  dynamic successAttemptCnt;
  dynamic isBlocked;
  dynamic status;
  dynamic remark;
  dynamic deviceId;

  User(
      {this.id,
      this.password,
      this.ciPassword,
      this.authId,
      this.createdDate,
      this.updatedDate,
      this.userHash,
      this.failedAttemptCnt,
      this.successAttemptCnt,
      this.isBlocked,
      this.status,
      this.remark,
      this.deviceId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    ciPassword = json['ci_password'];
    authId = json['auth_id'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    userHash = json['user_hash'];
    failedAttemptCnt = json['failed_attempt_cnt'];
    successAttemptCnt = json['success_attempt_cnt'];
    isBlocked = json['is_blocked'];
    status = json['status'];
    remark = json['remark'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['ci_password'] = this.ciPassword;
    data['auth_id'] = this.authId;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['user_hash'] = this.userHash;
    data['failed_attempt_cnt'] = this.failedAttemptCnt;
    data['success_attempt_cnt'] = this.successAttemptCnt;
    data['is_blocked'] = this.isBlocked;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['device_id'] = this.deviceId;
    return data;
  }
}

class UserDetails {
  dynamic id;
  dynamic salutation;
  dynamic firstName;
  dynamic middleName;
  dynamic lastName;
  dynamic sex;
  dynamic category;
  dynamic allocatedCategory;
  dynamic dob;
  dynamic email;
  dynamic photopath;
  dynamic maritalStatus;
  dynamic physicallyChallenged;
  dynamic deptId;
  dynamic updated;

  UserDetails(
      {this.id,
      this.salutation,
      this.firstName,
      this.middleName,
      this.lastName,
      this.sex,
      this.category,
      this.allocatedCategory,
      this.dob,
      this.email,
      this.photopath,
      this.maritalStatus,
      this.physicallyChallenged,
      this.deptId,
      this.updated});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salutation = json['salutation'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    sex = json['sex'];
    category = json['category'];
    allocatedCategory = json['allocated_category'];
    dob = json['dob'];
    email = json['email'];
    photopath = json['photopath'];
    maritalStatus = json['marital_status'];
    physicallyChallenged = json['physically_challenged'];
    deptId = json['dept_id'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salutation'] = this.salutation;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['sex'] = this.sex;
    data['category'] = this.category;
    data['allocated_category'] = this.allocatedCategory;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['photopath'] = this.photopath;
    data['marital_status'] = this.maritalStatus;
    data['physically_challenged'] = this.physicallyChallenged;
    data['dept_id'] = this.deptId;
    data['updated'] = this.updated;
    return data;
  }
}

class PreStuCourse {
  dynamic id;
  dynamic formId;
  dynamic admnNo;
  dynamic subOfferedId;
  dynamic subjectCode;
  dynamic courseAggrId;
  dynamic subjectName;
  dynamic priority;
  dynamic subCategory;
  dynamic subCategoryCbcsOffered;
  dynamic mapId;
  dynamic course;
  dynamic branch;
  dynamic sessionYear;
  dynamic session;
  dynamic remark1;
  dynamic remark2;
  dynamic remark3;
  dynamic createdAt;
  dynamic updatedAt;

  PreStuCourse(
      {this.id,
      this.formId,
      this.admnNo,
      this.subOfferedId,
      this.subjectCode,
      this.courseAggrId,
      this.subjectName,
      this.priority,
      this.subCategory,
      this.subCategoryCbcsOffered,
      this.mapId,
      this.course,
      this.branch,
      this.sessionYear,
      this.session,
      this.remark1,
      this.remark2,
      this.remark3,
      this.createdAt,
      this.updatedAt});

  PreStuCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['form_id'];
    admnNo = json['admn_no'];
    subOfferedId = json['sub_offered_id'];
    subjectCode = json['subject_code'];
    courseAggrId = json['course_aggr_id'];
    subjectName = json['subject_name'];
    priority = json['priority'];
    subCategory = json['sub_category'];
    subCategoryCbcsOffered = json['sub_category_cbcs_offered'];
    mapId = json['map_id'];
    course = json['course'];
    branch = json['branch'];
    sessionYear = json['session_year'];
    session = json['session'];
    remark1 = json['remark1'];
    remark2 = json['remark2'];
    remark3 = json['remark3'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['form_id'] = this.formId;
    data['admn_no'] = this.admnNo;
    data['sub_offered_id'] = this.subOfferedId;
    data['subject_code'] = this.subjectCode;
    data['course_aggr_id'] = this.courseAggrId;
    data['subject_name'] = this.subjectName;
    data['priority'] = this.priority;
    data['sub_category'] = this.subCategory;
    data['sub_category_cbcs_offered'] = this.subCategoryCbcsOffered;
    data['map_id'] = this.mapId;
    data['course'] = this.course;
    data['branch'] = this.branch;
    data['session_year'] = this.sessionYear;
    data['session'] = this.session;
    data['remark1'] = this.remark1;
    data['remark2'] = this.remark2;
    data['remark3'] = this.remark3;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CbcsStuCourse {
  dynamic id;
  dynamic formId;
  dynamic admnNo;
  dynamic subOfferedId;
  dynamic subjectCode;
  dynamic courseAggrId;
  dynamic subjectName;
  dynamic priority;
  dynamic subCategory;
  dynamic mapId;
  dynamic subCategoryCbcsOffered;
  dynamic course;
  dynamic branch;
  dynamic sessionYear;
  dynamic session;
  dynamic updatedAt;

  CbcsStuCourse(
      {this.id,
      this.formId,
      this.admnNo,
      this.subOfferedId,
      this.subjectCode,
      this.courseAggrId,
      this.subjectName,
      this.priority,
      this.subCategory,
      this.mapId,
      this.subCategoryCbcsOffered,
      this.course,
      this.branch,
      this.sessionYear,
      this.session,
      this.updatedAt});

  CbcsStuCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['form_id'];
    admnNo = json['admn_no'];
    subOfferedId = json['sub_offered_id'];
    subjectCode = json['subject_code'];
    courseAggrId = json['course_aggr_id'];
    subjectName = json['subject_name'];
    priority = json['priority'];
    subCategory = json['sub_category'];
    mapId = json['map_id'];
    subCategoryCbcsOffered = json['sub_category_cbcs_offered'];
    course = json['course'];
    branch = json['branch'];
    sessionYear = json['session_year'];
    session = json['session'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['form_id'] = this.formId;
    data['admn_no'] = this.admnNo;
    data['sub_offered_id'] = this.subOfferedId;
    data['subject_code'] = this.subjectCode;
    data['course_aggr_id'] = this.courseAggrId;
    data['subject_name'] = this.subjectName;
    data['priority'] = this.priority;
    data['sub_category'] = this.subCategory;
    data['map_id'] = this.mapId;
    data['sub_category_cbcs_offered'] = this.subCategoryCbcsOffered;
    data['course'] = this.course;
    data['branch'] = this.branch;
    data['session_year'] = this.sessionYear;
    data['session'] = this.session;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
