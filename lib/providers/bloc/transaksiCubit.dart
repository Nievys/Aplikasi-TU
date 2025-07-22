import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aplikasikkp/Utils/aesDecryption.dart';
import 'package:aplikasikkp/Utils/transaksiServices.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasikkp/auth/authServices.dart';

import '../../Utils/localDB.dart';
import '../../model/transaksi.dart';
import '../../model/transaksiResponse.dart';
part 'package:aplikasikkp/providers/state/transaksiState.dart';

class transaksiCubit extends Cubit<transaksiState> {
  final transaksiServices callthisapi;
  final TransactionStorageService transactionStorageService;

  transaksiCubit(this.callthisapi, this.transactionStorageService) : super(transaksiInitial());

  void AllTransaction(token) async {
    emit(transaksiLoading());
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var aesKey = localStorage.getString('decryption_key');
      List<int> keyBytes = base64.decode(aesKey!);
      String decodedKey = utf8.decode(keyBytes);
      transaksiResponse apiResponse = await callthisapi.getAllTransaction(token);
      if (apiResponse != null && apiResponse.dataTransaksi is List) {
        List<transaksi> processedTransactions = [];
        for (var currentTransaction in apiResponse.dataTransaksi) {
          String encryptedStatusLunas = currentTransaction.statusLunas;
          List<List<List<List<int>>>> ciphertextFormatted;
          try {
            dynamic decodedCiphertext = jsonDecode(encryptedStatusLunas);
            ciphertextFormatted = AesDecryptionUtil.parseCiphertext(jsonEncode(decodedCiphertext));
            List<String> hasildekrip = AesDecryptionUtil.decrypt(decodedKey, ciphertextFormatted);
            if (hasildekrip.isNotEmpty) {
              String decryptedStatus = hasildekrip.first;
              currentTransaction = transaksi(
                idTransaksi: currentTransaction.idTransaksi,
                idSpp: currentTransaction.idSpp,
                nama_kelas: currentTransaction.nama_kelas,
                bukti_pembayaran: currentTransaction.bukti_pembayaran,
                spp: currentTransaction.spp,
                potongan: currentTransaction.potongan,
                bukti_potongan: currentTransaction.bukti_potongan,
                bulan: currentTransaction.bulan,
                semester: currentTransaction.semester,
                tahunAjaran: currentTransaction.tahunAjaran,
                statusLunas: decryptedStatus,
                idKetuaKomite: currentTransaction.idKetuaKomite,
                namaKetuaKomite: currentTransaction.namaKetuaKomite,
                idKepalaSekolah: currentTransaction.idKepalaSekolah,
                kepalaSekolah: currentTransaction.kepalaSekolah,
                createdAt: currentTransaction.createdAt,
                updatedAt: currentTransaction.updatedAt,
                deletedAt: currentTransaction.deletedAt,
                createdBy: currentTransaction.createdBy,
                updatedBy: currentTransaction.updatedBy,
                deletedBy: currentTransaction.deletedBy,
                namaLengkap: currentTransaction.namaLengkap,
                idAccount: currentTransaction.idAccount,
                status_verifikasi: currentTransaction.status_verifikasi,
                id_verifikasi: currentTransaction.id_verifikasi,
                nisn: currentTransaction.nisn,
                id_NIS: currentTransaction.id_NIS,
              );
            } else {
              log('Warning: Decryption of statusLunas yielded no results for idTransaksi: ${currentTransaction.idTransaksi}');
            }
          } catch (decryptionError) {
            log('Stack trace: ${StackTrace.current}');
            log('Error decrypting statusLunas for idTransaksi: ${currentTransaction.idTransaksi}: $decryptionError');
            currentTransaction = transaksi(
              idTransaksi: currentTransaction.idTransaksi,
              idSpp: currentTransaction.idSpp,
              nama_kelas: currentTransaction.nama_kelas,
              bukti_pembayaran: currentTransaction.bukti_pembayaran,
              spp: currentTransaction.spp,
              potongan: currentTransaction.potongan,
              bukti_potongan: currentTransaction.bukti_potongan,
              bulan: currentTransaction.bulan,
              semester: currentTransaction.semester,
              tahunAjaran: currentTransaction.tahunAjaran,
              statusLunas: 'Decryption_Failed',
              idKetuaKomite: currentTransaction.idKetuaKomite,
              namaKetuaKomite: currentTransaction.namaKetuaKomite,
              idKepalaSekolah: currentTransaction.idKepalaSekolah,
              kepalaSekolah: currentTransaction.kepalaSekolah,
              createdAt: currentTransaction.createdAt,
              updatedAt: currentTransaction.updatedAt,
              deletedAt: currentTransaction.deletedAt,
              createdBy: currentTransaction.createdBy,
              updatedBy: currentTransaction.updatedBy,
              deletedBy: currentTransaction.deletedBy,
              namaLengkap: currentTransaction.namaLengkap,
              idAccount: currentTransaction.idAccount,
              status_verifikasi: currentTransaction.status_verifikasi,
              id_verifikasi: currentTransaction.id_verifikasi,
              nisn: currentTransaction.nisn,
              id_NIS: currentTransaction.id_NIS,
            );
          }
          processedTransactions.add(currentTransaction);
        }
        await transactionStorageService.deleteAllTransactions();
        await transactionStorageService.saveTransactions(processedTransactions);
        emit(transaksiSuccess(message: apiResponse.message));
      } else {
        emit(transaksiFailure(message: 'Data transaksi tidak ditemukan'));
      }
      } catch (e) {
      log('ERROR in AllTransaction: $e');
      log('Stack trace: ${StackTrace.current}');
      emit(transaksiFailure(message: e.toString()));
    }
  }
}