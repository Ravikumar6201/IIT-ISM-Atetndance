class TACourseData {
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

  TACourseData(
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

  TACourseData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['session_year'] = sessionYear;
    data['session'] = session;
    data['sub_code'] = subCode;
    data['sub_offered_id'] = subOfferedId;
    data['ft_id'] = ftId;
    data['admn_no'] = admnNo;
    data['remark'] = remark;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['session_year'] = sessionYear;
    data['session'] = session;
    data['sub_code'] = subCode;
    data['sub_offered_id'] = subOfferedId;
    data['ft_id'] = ftId;
    data['admn_no'] = admnNo;
    data['remark'] = remark;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    return data;
  }
}

class AssignTAList {
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
  dynamic sub_name;

  AssignTAList(
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
      this.modifiedAt,
      this.sub_name
      });

  AssignTAList.fromJson(Map<String, dynamic> json) {
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
     sub_name = json['sub_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['session_year'] = sessionYear;
    data['session'] = session;
    data['sub_code'] = subCode;
    data['sub_offered_id'] = subOfferedId;
    data['ft_id'] = ftId;
    data['admn_no'] = admnNo;
    data['remark'] = remark;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['sub_name'] = sub_name;
    return data;
  }
}
