// ignore_for_file: unnecessary_this

class StudentDataList {
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

  StudentDataList(
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

  StudentDataList.fromJson(Map<String, dynamic> json) {
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

  map(Function(dynamic s) param0) {}
}
