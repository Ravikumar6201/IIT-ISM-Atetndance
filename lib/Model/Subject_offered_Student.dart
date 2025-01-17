// ignore_for_file: unnecessary_this, camel_case_types

class Pre_SubjectOffered_Student {
  dynamic id;
  dynamic sessionYear;
  dynamic session;
  dynamic deptId;
  dynamic courseId;
  dynamic branchId;
  dynamic semester;
  dynamic uniqueSubPoolId;
  dynamic uniqueSubId;
  dynamic subName;
  dynamic subCode;
  dynamic lecture;
  dynamic tutorial;
  dynamic practical;
  dynamic creditHours;
  dynamic contactHours;
  dynamic subType;
  dynamic wefYear;
  dynamic wefSession;
  dynamic preRequisite;
  dynamic preRequisiteSubcode;
  dynamic fullmarks;
  dynamic noOfSubjects;
  dynamic subCategory;
  dynamic subGroup;
  dynamic criteria;
  dynamic minstu;
  dynamic maxstu;
  dynamic remarks;
  dynamic createdBy;
  dynamic createdOn;
  dynamic lastUpdatedBy;
  dynamic lastUpdatedOn;
  dynamic action;

  Pre_SubjectOffered_Student(
      {this.id,
      this.sessionYear,
      this.session,
      this.deptId,
      this.courseId,
      this.branchId,
      this.semester,
      this.uniqueSubPoolId,
      this.uniqueSubId,
      this.subName,
      this.subCode,
      this.lecture,
      this.tutorial,
      this.practical,
      this.creditHours,
      this.contactHours,
      this.subType,
      this.wefYear,
      this.wefSession,
      this.preRequisite,
      this.preRequisiteSubcode,
      this.fullmarks,
      this.noOfSubjects,
      this.subCategory,
      this.subGroup,
      this.criteria,
      this.minstu,
      this.maxstu,
      this.remarks,
      this.createdBy,
      this.createdOn,
      this.lastUpdatedBy,
      this.lastUpdatedOn,
      this.action});

  Pre_SubjectOffered_Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionYear = json['session_year'];
    session = json['session'];
    deptId = json['dept_id'];
    courseId = json['course_id'];
    branchId = json['branch_id'];
    semester = json['semester'];
    uniqueSubPoolId = json['unique_sub_pool_id'];
    uniqueSubId = json['unique_sub_id'];
    subName = json['sub_name'];
    subCode = json['sub_code'];
    lecture = json['lecture'];
    tutorial = json['tutorial'];
    practical = json['practical'];
    creditHours = json['credit_hours'];
    contactHours = json['contact_hours'];
    subType = json['sub_type'];
    wefYear = json['wef_year'];
    wefSession = json['wef_session'];
    preRequisite = json['pre_requisite'];
    preRequisiteSubcode = json['pre_requisite_subcode'];
    fullmarks = json['fullmarks'];
    noOfSubjects = json['no_of_subjects'];
    subCategory = json['sub_category'];
    subGroup = json['sub_group'];
    criteria = json['criteria'];
    minstu = json['minstu'];
    maxstu = json['maxstu'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    lastUpdatedBy = json['last_updated_by'];
    lastUpdatedOn = json['last_updated_on'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['session_year'] = this.sessionYear;
    data['session'] = this.session;
    data['dept_id'] = this.deptId;
    data['course_id'] = this.courseId;
    data['branch_id'] = this.branchId;
    data['semester'] = this.semester;
    data['unique_sub_pool_id'] = this.uniqueSubPoolId;
    data['unique_sub_id'] = this.uniqueSubId;
    data['sub_name'] = this.subName;
    data['sub_code'] = this.subCode;
    data['lecture'] = this.lecture;
    data['tutorial'] = this.tutorial;
    data['practical'] = this.practical;
    data['credit_hours'] = this.creditHours;
    data['contact_hours'] = this.contactHours;
    data['sub_type'] = this.subType;
    data['wef_year'] = this.wefYear;
    data['wef_session'] = this.wefSession;
    data['pre_requisite'] = this.preRequisite;
    data['pre_requisite_subcode'] = this.preRequisiteSubcode;
    data['fullmarks'] = this.fullmarks;
    data['no_of_subjects'] = this.noOfSubjects;
    data['sub_category'] = this.subCategory;
    data['sub_group'] = this.subGroup;
    data['criteria'] = this.criteria;
    data['minstu'] = this.minstu;
    data['maxstu'] = this.maxstu;
    data['remarks'] = this.remarks;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['last_updated_by'] = this.lastUpdatedBy;
    data['last_updated_on'] = this.lastUpdatedOn;
    data['action'] = this.action;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
