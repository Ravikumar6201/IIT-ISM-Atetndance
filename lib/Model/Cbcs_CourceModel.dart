class StudentData {
  dynamic descId;
  dynamic subOfferedId;
  dynamic part;
  dynamic empNo;
  dynamic coordinator;
  dynamic subId;
  dynamic section;
  dynamic sub_name;

  StudentData(
      {this.descId,
      this.subOfferedId,
      this.part,
      this.empNo,
      this.coordinator,
      this.subId,
      this.section,
      this.sub_name
      });

  StudentData.fromJson(Map<String, dynamic> json) {
    descId = json['desc_id'];
    subOfferedId = json['sub_offered_id'];
    part = json['part'];
    empNo = json['emp_no'];
    coordinator = json['coordinator'];
    subId = json['sub_id'];
    section = json['section'];
     sub_name = json['sub_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['desc_id'] = descId;
    data['sub_offered_id'] = subOfferedId;
    data['part'] = part;
    data['emp_no'] = empNo;
    data['coordinator'] = coordinator;
    data['sub_id'] = subId;
    data['section'] = section;
    data['sub_name'] = sub_name;
    return data;
  }
}
