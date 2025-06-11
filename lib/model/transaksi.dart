import 'dart:io';
import 'dart:convert';

class transaksi {
  final int idTransaksi;
  final int idSpp;
  final String spp;
  final String potongan;
  final int bulan;
  final int semester;
  final String tahunAjaran;
  final String statusLunas;
  final int? idKetuaKomite;
  final String? namaKetuaKomite;
  final int? idKepalaSekolah;
  final String? kepalaSekolah;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String createdBy;
  final String updatedBy;
  final String? deletedBy;
  final String namaLengkap;
  final int idAccount;

  transaksi({
    required this.idTransaksi,
    required this.idSpp,
    required this.spp,
    required this.potongan,
    required this.bulan,
    required this.semester,
    required this.tahunAjaran,
    required this.statusLunas,
    required this.idKetuaKomite,
    required this.namaKetuaKomite,
    required this.idKepalaSekolah,
    required this.kepalaSekolah,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    required this.namaLengkap,
    required this.idAccount,
  });

  factory transaksi.fromJson(Map<String, dynamic> json) {
    return transaksi(
      idTransaksi: json['id_transaksi'],
      idSpp: json['id_spp'],
      spp: json['spp'],
      potongan: json['potongan'],
      bulan: json['bulan'],
      semester: json['semester'],
      tahunAjaran: json['tahun_ajaran'],
      statusLunas: json['status_lunas'],
      idKetuaKomite: json['id_ketua_komite'],
      namaKetuaKomite: json['nama_ketua_komite'],
      idKepalaSekolah: json['id_kepala_sekolah'],
      kepalaSekolah: json['kepala_sekolah'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      namaLengkap: json['nama_lengkap'],
      idAccount: json['id_account'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_transaksi': idTransaksi,
    'id_spp': idSpp,
    'spp': spp,
    'potongan': potongan,
    'bulan': bulan,
    'semester': semester,
    'tahun_ajaran': tahunAjaran,
    'status_lunas': statusLunas,
    'id_ketua_komite': idKetuaKomite,
    'nama_ketua_komite': namaKetuaKomite,
    'id_kepala_sekolah': idKepalaSekolah,
    'kepala_sekolah': kepalaSekolah,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'deleted_by': deletedBy,
    'nama_lengkap': namaLengkap,
    'id_account': idAccount,
  };
}