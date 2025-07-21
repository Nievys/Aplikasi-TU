import 'dart:io';
import 'dart:convert';

class transaksi {
  final int idTransaksi;
  final int idSpp;
  final String nama_kelas;
  final String? bukti_pembayaran;
  final String spp;
  final String potongan;
  final String? bukti_potongan;
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
  final int createdBy;
  final int? updatedBy;
  final int? deletedBy;
  final String namaLengkap;
  final int idAccount;
  final int? status_verifikasi;
  final int id_verifikasi;
  final String nisn;
  final String id_NIS;

  transaksi({
    required this.idTransaksi,
    required this.idSpp,
    required this.nama_kelas,
    this.bukti_pembayaran,
    required this.spp,
    required this.potongan,
    this.bukti_potongan,
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
    this.updatedBy,
    this.deletedBy,
    required this.namaLengkap,
    required this.idAccount,
    this.status_verifikasi,
    required this.id_verifikasi,
    required this.nisn,
    required this.id_NIS,
  });

  transaksi copyWith({
    int? status_verifikasi,
  }) {
    return transaksi(
      idTransaksi: this.idTransaksi,
      idSpp: this.idSpp,
      nama_kelas: this.nama_kelas,
      bukti_pembayaran: this.bukti_pembayaran,
      spp: this.spp,
      potongan: this.potongan,
      bukti_potongan: this.bukti_potongan,
      bulan: this.bulan,
      semester: this.semester,
      tahunAjaran: this.tahunAjaran,
      statusLunas: this.statusLunas,
      idKetuaKomite: this.idKetuaKomite,
      namaKetuaKomite: this.namaKetuaKomite,
      idKepalaSekolah: this.idKepalaSekolah,
      kepalaSekolah: this.kepalaSekolah,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      deletedAt: this.deletedAt,
      createdBy: this.createdBy,
      updatedBy: this.updatedBy,
      deletedBy: this.deletedBy,
      namaLengkap: this.namaLengkap,
      idAccount: this.idAccount,
      status_verifikasi: status_verifikasi ?? this.status_verifikasi,
      id_verifikasi: this.id_verifikasi,
      nisn: this.nisn,
      id_NIS: this.id_NIS,
    );
  }

  factory transaksi.fromJson(Map<String, dynamic> json) {
    return transaksi(
      idTransaksi: json['id_transaksi'],
      idSpp: json['id_spp'],
      nama_kelas: json['nama_kelas'] ?? '',
      bukti_pembayaran: json['bukti_pembayaran'],
      spp: json['spp'],
      potongan: json['potongan'],
      bukti_potongan: json['bukti_potongan'],
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
      status_verifikasi: json['status_verifikasi'],
      id_verifikasi: json['id_verifikasi'],
      nisn: json['nisn'],
      id_NIS: json['id_NIS'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_transaksi': idTransaksi,
    'id_spp': idSpp,
    'nama_kelas': nama_kelas,
    'bukti_pembayaran': bukti_pembayaran,
    'spp': spp,
    'potongan': potongan,
    'bukti_potongan': bukti_potongan,
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
    'status_verifikasi': status_verifikasi ?? false,
    'id_verifikasi': id_verifikasi,
    'nisn': nisn,
    'id_NIS': id_NIS,
  };
}