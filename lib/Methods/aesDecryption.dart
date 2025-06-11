// aesDecryption.dart
// (Path: lib/utils/aesDecryption.dart atau sesuaikan dengan struktur proyek Anda)

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

// Kelas AESDecryption akan tetap berisi semua logika enkripsi/dekripsi
class AESDecryption {
  static const List<int> rcon = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36];

  // S-box for AES
  static const List<List<int>> sbox = [
    [0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76],
    [0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0],
    [0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15],
    [0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75],
    [0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84],
    [0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf],
    [0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8],
    [0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2],
    [0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73],
    [0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb],
    [0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79],
    [0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08],
    [0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a],
    [0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e],
    [0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf],
    [0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16]
  ];

  // Inverse S-box for AES
  static const List<List<int>> inverseSbox = [
    [0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb],
    [0x7c,0xe3,0x39,0x82,0x9b,0x2f,0xff,0x87,0x34,0x8e,0x43,0x44,0xc4,0xde,0xe9,0xcb],
    [0x54,0x7b,0x94,0x32,0xa6,0xc2,0x23,0x3d,0xee,0x4c,0x95,0x0b,0x42,0xfa,0xc3,0x4e],
    [0x08,0x2e,0xa1,0x66,0x28,0xd9,0x24,0xb2,0x76,0x5b,0xa2,0x49,0x6d,0x8b,0xd1,0x25],
    [0x72,0xf8,0xf6,0x64,0x86,0x68,0x98,0x16,0xd4,0xa4,0x5c,0xcc,0x5d,0x65,0xb6,0x92],
    [0x6c,0x70,0x48,0x50,0xfd,0xed,0xb9,0xda,0x5e,0x15,0x46,0x57,0xa7,0x8d,0x9d,0x84],
    [0x90,0xd8,0xab,0x00,0x8c,0xbc,0xd3,0x0a,0xf7,0xe4,0x58,0x05,0xb8,0xb3,0x45,0x06],
    [0xd0,0x2c,0x1e,0x8f,0xca,0x3f,0x0f,0x02,0xc1,0xaf,0xbd,0x03,0x01,0x13,0x8a,0x6b],
    [0x3a,0x91,0x11,0x41,0x4f,0x67,0xdc,0xea,0x97,0xf2,0xcf,0xce,0xf0,0xb4,0xe6,0x73],
    [0x96,0xac,0x74,0x22,0xe7,0xad,0x35,0x85,0xe2,0xf9,0x37,0xe8,0x1c,0x75,0xdf,0x6e],
    [0x47,0xf1,0x1a,0x71,0x1d,0x29,0xc5,0x89,0x6f,0xb7,0x62,0x0e,0xaa,0x18,0xbe,0x1b],
    [0xfc,0x56,0x3e,0x4b,0xc6,0xd2,0x79,0x20,0x9a,0xdb,0xc0,0xfe,0x78,0xcd,0x5a,0xf4],
    [0x1f,0xdd,0xa8,0x33,0x88,0x07,0xc7,0x31,0xb1,0x12,0x10,0x59,0x27,0x80,0xec,0x5f],
    [0x60,0x51,0x7f,0xa9,0x19,0xb5,0x4a,0x0d,0x2d,0xe5,0x7a,0x9f,0x93,0xc9,0x9c,0xef],
    [0xa0,0xe0,0x3b,0x4d,0xae,0x2a,0xf5,0xb0,0xc8,0xeb,0xbb,0x3c,0x83,0x53,0x99,0x61],
    [0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d]
  ];

  // Convert input values to bytes with padding
  static List<List<int>> convertInputValueToBytes(bool debugging, List<String> values) {
    List<List<int>> result = [];

    for (String value in values) {
      List<int> bytes = utf8.encode(value);
      int size = bytes.length % 16 == 0 ? 0 : 16 - (bytes.length % 16);

      // Add padding
      for (int i = 0; i < size; i++) {
        bytes.add(0);
      }

      if (debugging) {
        print('\nValue: $value');
        print('Length: ${bytes.length}');
        print('Size added: $size');
        for (int i = 0; i < bytes.length; i++) {
          print('Index: $i \tByte: ${bytes[i]} \tHex: ${bytes[i].toRadixString(16)} \tBit: ${bytes[i].toRadixString(2).padLeft(8, '0')} \tASCII: ${String.fromCharCode(bytes[i])}');
        }
      }

      result.add(bytes);
    }

    return result;
  }

  // Key expansion function
  static List<List<List<int>>> keyExpansion(bool debugging, List<int> key) {
    List<List<List<int>>> rkey = [];

    for (int i = 0; i < 8; i++) {
      List<List<int>> matrix1 = List.generate(4, (_) => List.filled(4, 0));
      List<List<int>> matrix2 = List.generate(4, (_) => List.filled(4, 0));

      if (i == 0) {
        // Insert original key
        for (int y = 0; y < 4; y++) {
          for (int x = 0; x < 4; x++) {
            matrix1[x][y] = key[y * 4 + x];
            matrix2[x][y] = key[y * 4 + x + 16];
          }
        }
      } else {
        // Main key expansion process
        List<List<int>> prevMatrix = List.generate(4, (_) => List.filled(8, 0));

        for (int x = 0; x < 4; x++) {
          List<int> combined = [];
          combined.addAll(rkey[i * 2 - 2][x]);
          combined.addAll(rkey[i * 2 - 1][x]);
          prevMatrix[x] = combined;
        }

        for (int y = 0; y < 8; y++) {
          List<int> xorArr = List.filled(4, 0);

          if (y == 0) {
            // Column 0: shift, s-box, and xor with rcon
            List<int> subData = List.filled(4, 0);
            List<int> shifted = shiftColumns(debugging, [
              prevMatrix[0][7], prevMatrix[1][7], prevMatrix[2][7], prevMatrix[3][7]
            ]);

            for (int x = 0; x < 4; x++) {
              subData[x] = substitutionBox(debugging, shifted[x]);
            }

            for (int x = 0; x < 4; x++) {
              if (x == 0) {
                xorArr[x] = subData[x] ^ rcon[i - 1];
                if (debugging) {
                  print('rcon: dec: ${rcon[i - 1]} bit: ${rcon[i - 1].toRadixString(2).padLeft(8, '0')}');
                }
              } else {
                xorArr[x] = subData[x];
              }
              if (debugging) {
                print('sub_data: dec: ${subData[x]} bit: ${subData[x].toRadixString(2).padLeft(8, '0')}');
              }
            }
          } else if (y == 4) {
            // Column 4: only s-box
            for (int x = 0; x < 4; x++) {
              xorArr[x] = substitutionBox(debugging, prevMatrix[x][y - 1]);
            }
          } else {
            // Other columns
            for (int x = 0; x < 4; x++) {
              xorArr[x] = prevMatrix[x][y - 1];
            }
          }

          // XOR process
          for (int x = 0; x < 4; x++) {
            if (debugging) {
              print('prev_matrix: dec: ${prevMatrix[x][y]} bit: ${prevMatrix[x][y].toRadixString(2).padLeft(8, '0')}');
            }

            prevMatrix[x][y] = xorArr[x] ^ prevMatrix[x][y];

            if (debugging) {
              print('xor_arr: ${xorArr[x].toRadixString(2).padLeft(8, '0')}');
              print('current: dec: ${prevMatrix[x][y]} bit: ${prevMatrix[x][y].toRadixString(2).padLeft(8, '0')}');
            }
          }
        }

        // Split prev matrix into two 4x4 matrices
        for (int x = 0; x < 4; x++) {
          matrix1[x] = prevMatrix[x].sublist(0, 4);
          matrix2[x] = prevMatrix[x].sublist(4, 8);
        }
      }

      rkey.add(matrix1);
      rkey.add(matrix2);
    }

    if (debugging) {
      print('RCON: $rcon');
      for (int index = 0; index < rkey.length; index++) {
        print('\nkey matrix ke : $index');
        for (int i = 0; i < 4; i++) {
          print('${rkey[index][i]}');
        }
      }
    }

    return rkey;
  }

  // Shift columns to the left
  static List<int> shiftColumns(bool debugging, List<int> word) {
    List<int> shifted = [word[1], word[2], word[3], word[0]];

    if (debugging) {
      print('origin: $word');
      print('altered: $shifted');
    }

    return shifted;
  }

  // Add round key (XOR matrix with key)
  static List<List<int>> addRoundKey(List<List<int>> matrix, List<List<int>> key) {
    List<List<int>> result = List.generate(4, (i) => List.generate(4, (j) => matrix[i][j] ^ key[i][j]));
    return result;
  }

  // Substitution box
  static int substitutionBox(bool debugging, int data) {
    int mod16 = data % 16;
    int base16 = (data - mod16) ~/ 16;
    int subData = sbox[base16][mod16];

    if (debugging) {
      print('origin: hex: ${data.toRadixString(16)} dec: $data');
      print('baris: ${base16.toRadixString(16)}');
      print('kolom: ${mod16.toRadixString(16)}');
      print('sub data: ${subData.toRadixString(16)}');
    }

    return subData;
  }

  // Inverse substitution box
  static int inverseSboxdisini(bool debugging, int data) {
    int mod16 = data % 16;
    int base16 = (data - mod16) ~/ 16;
    int subData = inverseSbox[base16][mod16];

    if (debugging) {
      print('origin: hex: ${data.toRadixString(16)} dec: $data');
      print('baris: ${base16.toRadixString(16)}');
      print('kolom: ${mod16.toRadixString(16)}');
      print('sub data: ${subData.toRadixString(16)}');
    }

    return subData;
  }

  // Inverse shift rows
  static List<List<int>> inverseShiftRows(List<List<int>> matrix) {
    List<List<int>> result = List.generate(4, (_) => List.filled(4, 0));

    for (int x = 0; x < 4; x++) {
      List<int> row = List.from(matrix[x]);
      int shift = 4 - x;
      List<int> a = row.sublist(0, shift);
      List<int> b = row.sublist(shift);

      int y = 0;
      for (int i = 0; i < b.length; i++) {
        result[x][y] = b[i];
        y++;
      }
      for (int i = 0; i < a.length; i++) {
        result[x][y] = a[i];
        y++;
      }
    }

    return result;
  }

  // Inverse mix columns
  static List<List<int>> inverseMixColumns(bool debugging, List<List<int>> matrix) {
    List<List<int>> result = List.generate(4, (_) => List.filled(4, 0));

    const List<List<int>> inverseMatrixMultiplication = [
      [0x0E, 0x0B, 0x0D, 0x09],
      [0x09, 0x0E, 0x0B, 0x0D],
      [0x0D, 0x09, 0x0E, 0x0B],
      [0x0B, 0x0D, 0x09, 0x0E]
    ];

    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        for (int z = 0; z < 4; z++) {
          int gf = gf258(inverseMatrixMultiplication[x][z], matrix[z][y]);
          int res = result[x][y] ^ gf;

          if (debugging) {
            print('________________________________________________________________________');
            print('matrix[$x][$z]: ${matrix[x][z].toRadixString(2).padLeft(8, '0')} ${matrix[x][z].toRadixString(16)}');
            print('inverse_matrix_multiplication[$z][$y]: ${inverseMatrixMultiplication[z][y].toRadixString(2).padLeft(8, '0')} ${inverseMatrixMultiplication[z][y].toRadixString(16)}');
            print('gf258: ${gf.toRadixString(2).padLeft(8, '0')}');
            print('awal[$x][$y]: ${result[x][y].toRadixString(2).padLeft(8, '0')}');
            print('xor: ${res.toRadixString(2).padLeft(8, '0')}');
          }

          result[x][y] = res;

          if (debugging) {
            print('stored[$x][$y]: ${result[x][y].toRadixString(2).padLeft(8, '0')}');
          }
        }
      }
    }

    return result;
  }

  // Galois Field 2^8 multiplication
  static int gf258(int x, int y) {
    const int p = 0x11B; // 0b100011011
    int m = 0;

    for (int i = 0; i < 8; i++) {
      m = m << 1;
      if ((m & 0x100) != 0) {
        m = m ^ p;
      }

      if ((y & 0x80) != 0) {
        m = m ^ x;
      }
      y = y << 1;
    }

    return m & 0xFF;
  }

  // Main decryption function (one round)
  static List<List<int>> decryption(bool debugging, List<List<int>> matrix, List<List<List<int>>> rkeys) {
    List<List<int>> result = List.generate(4, (i) => List.from(matrix[i]));

    // Initial add_round_key
    result = addRoundKey(result, rkeys[0]);

    // 13 main rounds
    for (int i = 1; i < rkeys.length - 1; i++) {
      // Inverse ShiftRows
      result = inverseShiftRows(result);

      // Inverse SubBytes
      for (int x = 0; x < 4; x++) {
        for (int y = 0; y < 4; y++) {
          result[x][y] = inverseSboxdisini(debugging, result[x][y]);
        }
      }

      // AddRoundKey
      result = addRoundKey(result, rkeys[i]);

      // Inverse MixColumns
      result = inverseMixColumns(debugging, result);
    }

    // Final round (no Inverse MixColumns)
    result = inverseShiftRows(result);
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        result[x][y] = inverseSboxdisini(debugging, result[x][y]);
      }
    }
    result = addRoundKey(result, rkeys[rkeys.length - 1]);

    return result;
  }

  // Fungsi publik 'decrypt' yang akan dipanggil dari luar
  static List<String> decrypt(String key, String ciphertextJson, {bool debugging = false}) {
    // Validate key length
    if (key.length != 32) {
      throw ArgumentError('Input for key must be 32 characters long');
    }

    // Pastikan ciphertextJson adalah string JSON valid yang berisi 'cyphertext'
    Map<String, dynamic> json = jsonDecode(ciphertextJson);
    List<dynamic> cyphertextArray = json['cyphertext'];

    // Convert JSON to matrix format
    // Struktur input yang diharapkan untuk dekripsi per blok adalah List<List<int>> (4x4 matrix)
    List<List<List<int>>> ciphertextMatrices = [];

    // Iterasi melalui cyphertextArray (yang bisa berlapis)
    // Berdasarkan contoh JSON yang Anda berikan sebelumnya:
    // "status_lunas": "[[[[52,249,182,150],[157,73,114,127],[220,4,67,215],[241,29,63,31]]]]"
    // Ini menunjukkan array satu elemen yang berisi array satu elemen yang berisi array 4x4 matrix.
    // Kita perlu menyesuaikan parsing agar sesuai dengan struktur ini.

    // Asumsi: cyphertextArray adalah List<dynamic>
    // Iterasi tingkat pertama (misal, [ [ ...blok pertama... ], [ ...blok kedua... ] ] )
    try {
      // Level 1: Ambil array terluar. Harus List<dynamic>
      List<dynamic> level1 = cyphertextArray; // Tidak perlu `as List<dynamic>` jika sudah yakin
      if (debugging) {
        log('DEBUG (AESDecryption): Level 1 type: ${level1.runtimeType}, length: ${level1.length}');
      }

      // Level 2: Ambil elemen pertama dari level 1. Harus List<dynamic>
      List<dynamic> level2 = level1[0]; // Tidak perlu `as List<dynamic>`
      if (debugging) {
        log('DEBUG (AESDecryption): Level 2 type: ${level2.runtimeType}, length: ${level2.length}');
      }

      // Level 3: Ambil elemen pertama dari level 2. Ini adalah ARRAY DARI BARIS-BARIS (SATU MATRIKS 4x4)
      List<dynamic> currentMatrixJson = level2[0]; // <<< INI ADALAH SATU MATRIKS (List of Rows)
      if (debugging) {
        log('DEBUG (AESDecryption): currentMatrixJson type: ${currentMatrixJson.runtimeType}, length: ${currentMatrixJson.length}');
        log('DEBUG (AESDecryption): currentMatrixJson: $currentMatrixJson');
      }

      // Loop langsung melalui `currentMatrixJson` karena itu adalah daftar baris.
      List<List<int>> matrix = [];
      for (int i = 0; i < currentMatrixJson.length; i++) {
        // currentMatrixJson[i] adalah sebuah baris (List<int>)
        List<dynamic> rowData = currentMatrixJson[i] as List<dynamic>; // Cast baris ke List<dynamic>
        List<int> row = [];
        for (int j = 0; j < rowData.length; j++) {
          row.add(rowData[j] as int); // Cast byte ke int
        }
        matrix.add(row);
      }

      ciphertextMatrices.add(matrix); // Tambahkan matriks yang sudah diproses

      if (debugging) {
        log('DEBUG (AESDecryption): Successfully parsed matrix: $matrix');
        log('DEBUG (AESDecryption): Total parsed matrices: ${ciphertextMatrices.length}');
      }

    } catch (e) {
      log('ERROR (AESDecryption): Error parsing cyphertext structure: $e');
      // Melemparkan ulang FormatException dengan pesan yang lebih informatif
      throw FormatException('Error parsing cyphertext structure. Detailed error: $e');
    }


    // Convert key to bytes
    List<List<int>> keyBytes = convertInputValueToBytes(debugging, [key]);

    // Create round keys (reversed for decryption)
    // Pastikan keyBytes[0] adalah List<int> (single byte array for the key)
    List<List<List<int>>> rkeys = keyExpansion(debugging, keyBytes[0]).reversed.toList();

    // Decrypt data
    List<List<List<int>>> plaintextMatrices = []; // Mengumpulkan hasil dekripsi per blok
    for (int index = 0; index < ciphertextMatrices.length; index++) {
      if (debugging) {
        print('\ndecrypting block: $index');
      }

      // Panggil fungsi decryption untuk setiap matrix 4x4
      List<List<int>> decryptionResult = decryption(debugging, ciphertextMatrices[index], rkeys);
      plaintextMatrices.add(decryptionResult);
    }

    // Convert result to strings
    List<String> resultArray = [];
    for (var matrix in plaintextMatrices) {
      String result = '';
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          // Akses matrix[j][i] karena AES biasanya memproses kolom-major,
          // sedangkan representasi string mungkin baris-major.
          // Ini sudah benar dari kode asli Anda.
          log('DEBUG (AESDecryption): Decrypted Byte: ${matrix[j][i]} (Hex: ${matrix[j][i].toRadixString(16)})');
          result += String.fromCharCode(matrix[j][i]);
        }
      }
      // Trim dan hapus null bytes (padding)
      log('DEBUG (AESDecryption): Raw String Before Trim: "$result"');
      resultArray.add(result.trim().replaceAll(RegExp(r'\x00'), ''));
    }

    return resultArray;
  }
}

// Catatan: Fungsi main() yang sebelumnya ada di sini telah dihapus.
// Jika Anda ingin menguji AESDecryption secara terpisah, Anda bisa membuat
// file test Dart terpisah atau memanggilnya dari fungsi main() di main.dart
// untuk tujuan debugging.