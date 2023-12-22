class Reveil {
  String? id;
  String? startDate;
  String? endDate;
  bool? active;

  Reveil({
    this.id,
    this.startDate,
    this.endDate,
    this.active,
  });

  Reveil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['active'] = active;
    return data;
  }
}
