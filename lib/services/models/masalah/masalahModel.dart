import 'dart:convert';

// "idmasalah": 3016,
//             "jam": "11:00:00",
//             "tanggal": "2021-10-19T08:00:00.000Z",
//             "masalah": "Ban Dalam + Ban Perut Sobek",
//             "shift": 1,
//             "idmesin": 145,
//             "idpengguna": null,
//             "nomesin": "L 9281 UK",
//             "ketmesin": "Canter FE 75 SHD ( SIGK )",
//             "site": "Otomotif",
//             "idpenyelesaian": "3035",
//             "status": 1

class MasalahModel {
  var idmasalah, idmesin, idpenyelesaian, status, shift;
  var jam, tanggal, masalah, nomesin, ketmesin, site;

  MasalahModel(
      {this.idmasalah,
      this.idmesin,
      this.idpenyelesaian,
      this.status,
      this.shift,
      this.jam,
      this.tanggal,
      this.masalah,
      this.nomesin,
      this.ketmesin,
      this.site});

  factory MasalahModel.fromJson(Map<String, dynamic> map) {
    return MasalahModel(
        idmasalah: map['idmasalah'],
        idmesin: map['idmesin'],
        idpenyelesaian: map['idpenyelesaian'],
        status: map['status'],
        shift: map['shift'],
        jam: map['jam'],
        tanggal: map['tanggal'],
        masalah: map['masalah'],
        nomesin: map['nomesin'],
        ketmesin: map['ketmesin'],
        site: map['site']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idmasalah": idmasalah,
      "idmesin": idmesin,
      "idpenyelesaian": idpenyelesaian,
      "status": status,
      "shift": shift,
      "jam": jam,
      "tanggal": tanggal,
      "masalah": masalah,
      "nomesin": nomesin,
      "ketmesin": ketmesin,
      "site": site,
    };
  }

  @override
  String toString() {
    return 'MasalahModel{idmasalah: $idmasalah, idmesin: $idmesin,idpenyelesaian: $idpenyelesaian,status: $status,shift: $shift, jam: $jam, masalah: $masalah, nomesin: $nomesin, ketmesin: $ketmesin, site: $site}';
  }
}

List<MasalahModel> masalahFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<MasalahModel>.from(
      data["data"].map((item) => MasalahModel.fromJson(item)));
}

String masalahToJson(MasalahModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
