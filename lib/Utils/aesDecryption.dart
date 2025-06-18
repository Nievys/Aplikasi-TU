import 'dart:convert';

class AesDecryptionUtil {
  static const bool _debugging = false; // Set to true for debug output

  /// Main decryption function that takes key and ciphertext
  /// Returns list of decrypted strings
  static List<String> decrypt(String key, List<List<List<List<int>>>> ciphertext) {
    // Validate key length
    if (key.length != 32) {
      throw ArgumentError("Input for key must be 32 characters long");
    }

    // Convert key to bytes
    List<List<int>> keyBytes = convertInputValueToBytes(_debugging, [key]);

    // Create round keys using custom key expansion
    List<List<List<int>>> rkeys = _keyExpansion(
      _debugging,
      keyBytes[0],
    ).reversed.toList();

    // Decrypt each data block
    List<List<List<List<int>>>> plaintext = [];

    for (int index = 0; index < ciphertext.length; index++) {
      List<List<List<int>>> data = ciphertext[index];

      if (_debugging) {
        print("\ndata: $index");
      }

      List<List<List<int>>> decrypted = [];
      for (List<List<int>> matrix in data) {
        List<List<int>> decryptionResult = decryption(_debugging, matrix, rkeys);
        decrypted.add(decryptionResult);
      }
      plaintext.add(decrypted);
    }

    // Convert decrypted matrices back to strings
    List<String> resultArray = [];
    for (List<List<List<int>>> data in plaintext) {
      String result = '';
      for (List<List<int>> matrix in data) {
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 4; j++) {
            result += String.fromCharCode(matrix[j][i]);
          }
        }
      }
      resultArray.add(result.replaceAll(String.fromCharCode(0), '').trim());
    }

    return resultArray;
  }

  /// Parse JSON string to ciphertext format
  static List<List<List<List<int>>>> parseCiphertext(String jsonString) {
    try {
      return List<List<List<List<int>>>>.from(
        jsonDecode(jsonString).map(
              (x) => List<List<List<int>>>.from(
            x.map((y) => List<List<int>>.from(y.map((z) => List<int>.from(z)))),
          ),
        ),
      );
    } catch (e) {
      throw FormatException("Invalid ciphertext format: $e");
    }
  }

  /// Convert input strings to bytes
  static List<List<int>> convertInputValueToBytes(
      bool debugging,
      List<String> values,
      ) {
    List<List<int>> result = [];

    for (String value in values) {
      List<int> bytes = utf8.encode(value).toList();
      int size = bytes.length % 16 == 0 ? 0 : 16 - (value.length % 16);
      bytes.addAll(List.filled(size, 0));
      result.add(bytes);
    }
    return result;
  }

  /// Shift columns to the left
  static List<int> shiftColumns(bool debugging, List<int> word) {
    List<int> shifted = [word[1], word[2], word[3], word[0]];
    if (debugging == true) {
      print("orgin\t:$word");
      print("altered\t:$shifted");
    }
    return shifted;
  }

  /// AES S-Box substitution
  static int substitutionBox(bool debugging, int data) {
    List<List<int>> sbox = [
      [
        0x63,
        0x7c,
        0x77,
        0x7b,
        0xf2,
        0x6b,
        0x6f,
        0xc5,
        0x30,
        0x01,
        0x67,
        0x2b,
        0xfe,
        0xd7,
        0xab,
        0x76,
      ],
      [
        0xca,
        0x82,
        0xc9,
        0x7d,
        0xfa,
        0x59,
        0x47,
        0xf0,
        0xad,
        0xd4,
        0xa2,
        0xaf,
        0x9c,
        0xa4,
        0x72,
        0xc0,
      ],
      [
        0xb7,
        0xfd,
        0x93,
        0x26,
        0x36,
        0x3f,
        0xf7,
        0xcc,
        0x34,
        0xa5,
        0xe5,
        0xf1,
        0x71,
        0xd8,
        0x31,
        0x15,
      ],
      [
        0x04,
        0xc7,
        0x23,
        0xc3,
        0x18,
        0x96,
        0x05,
        0x9a,
        0x07,
        0x12,
        0x80,
        0xe2,
        0xeb,
        0x27,
        0xb2,
        0x75,
      ],
      [
        0x09,
        0x83,
        0x2c,
        0x1a,
        0x1b,
        0x6e,
        0x5a,
        0xa0,
        0x52,
        0x3b,
        0xd6,
        0xb3,
        0x29,
        0xe3,
        0x2f,
        0x84,
      ],
      [
        0x53,
        0xd1,
        0x00,
        0xed,
        0x20,
        0xfc,
        0xb1,
        0x5b,
        0x6a,
        0xcb,
        0xbe,
        0x39,
        0x4a,
        0x4c,
        0x58,
        0xcf,
      ],
      [
        0xd0,
        0xef,
        0xaa,
        0xfb,
        0x43,
        0x4d,
        0x33,
        0x85,
        0x45,
        0xf9,
        0x02,
        0x7f,
        0x50,
        0x3c,
        0x9f,
        0xa8,
      ],
      [
        0x51,
        0xa3,
        0x40,
        0x8f,
        0x92,
        0x9d,
        0x38,
        0xf5,
        0xbc,
        0xb6,
        0xda,
        0x21,
        0x10,
        0xff,
        0xf3,
        0xd2,
      ],
      [
        0xcd,
        0x0c,
        0x13,
        0xec,
        0x5f,
        0x97,
        0x44,
        0x17,
        0xc4,
        0xa7,
        0x7e,
        0x3d,
        0x64,
        0x5d,
        0x19,
        0x73,
      ],
      [
        0x60,
        0x81,
        0x4f,
        0xdc,
        0x22,
        0x2a,
        0x90,
        0x88,
        0x46,
        0xee,
        0xb8,
        0x14,
        0xde,
        0x5e,
        0x0b,
        0xdb,
      ],
      [
        0xe0,
        0x32,
        0x3a,
        0x0a,
        0x49,
        0x06,
        0x24,
        0x5c,
        0xc2,
        0xd3,
        0xac,
        0x62,
        0x91,
        0x95,
        0xe4,
        0x79,
      ],
      [
        0xe7,
        0xc8,
        0x37,
        0x6d,
        0x8d,
        0xd5,
        0x4e,
        0xa9,
        0x6c,
        0x56,
        0xf4,
        0xea,
        0x65,
        0x7a,
        0xae,
        0x08,
      ],
      [
        0xba,
        0x78,
        0x25,
        0x2e,
        0x1c,
        0xa6,
        0xb4,
        0xc6,
        0xe8,
        0xdd,
        0x74,
        0x1f,
        0x4b,
        0xbd,
        0x8b,
        0x8a,
      ],
      [
        0x70,
        0x3e,
        0xb5,
        0x66,
        0x48,
        0x03,
        0xf6,
        0x0e,
        0x61,
        0x35,
        0x57,
        0xb9,
        0x86,
        0xc1,
        0x1d,
        0x9e,
      ],
      [
        0xe1,
        0xf8,
        0x98,
        0x11,
        0x69,
        0xd9,
        0x8e,
        0x94,
        0x9b,
        0x1e,
        0x87,
        0xe9,
        0xce,
        0x55,
        0x28,
        0xdf,
      ],
      [
        0x8c,
        0xa1,
        0x89,
        0x0d,
        0xbf,
        0xe6,
        0x42,
        0x68,
        0x41,
        0x99,
        0x2d,
        0x0f,
        0xb0,
        0x54,
        0xbb,
        0x16,
      ],
    ];

    // kolom / col / x
    int mod16 = data % 16;
    // baris / row / y
    int base16 = (data - mod16) ~/ 16;
    // ambil data substitution box
    int subData = sbox[base16][mod16];

    if (debugging == true) {
      print("orgin\t\t:hex:${data.toRadixString(16)}\t: dec:$data");
      print("baris\t\t:${base16.toRadixString(16)}");
      print("kolom\t\t:${mod16.toRadixString(16)}");
      print("sub data\t:${subData.toRadixString(16)}");
    }
    return subData;
  }

  /// Custom key expansion function
  static List<List<List<int>>> _keyExpansion(bool debugging, List<int> key) {
    List<int> rcon = [
      0x01,
      0x02,
      0x04,
      0x08,
      0x10,
      0x20,
      0x40,
      0x80,
      0x1B,
      0x36,
    ];
    List<List<List<int>>> rkey = [];

    for (int i = 0; i < 8; i++) {
      List<List<int>> matrix1 = List.generate(4, (_) => List.filled(4, 0));
      List<List<int>> matrix2 = List.generate(4, (_) => List.filled(4, 0));

      switch (i) {
      // masukin key original
        case 0:
          for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++) {
              matrix1[x][y] = key[y * 4 + x];
              matrix2[x][y] = key[y * 4 + x + 16];
            }
          }
          break;

      // proses key expansion utama
        default:
          if (i >= 1 && i <= 8) {
            // buat prev matrix 8x4 nuat mempermudah penghitungan
            List<List<int>> prevMatrix = List.generate(
              4,
                  (_) => List.filled(8, 0),
            );
            for (int x = 0; x < 4; x++) {
              List<int> combined = [];
              combined.addAll(rkey[i * 2 - 2][x]);
              combined.addAll(rkey[i * 2 - 1][x]);
              prevMatrix[x] = combined;
            }

            // buat oprasi matrix per kolom beda beda
            for (int y = 0; y < 8; y++) {
              List<int> xorArr = List.filled(4, 0);

              // kolom 0 arr yang di xor kan perlu ada shift dan s box dan di xor
              if (y == 0) {
                List<int> subData = List.filled(4, 0);
                List<int> shifted = shiftColumns(debugging, [
                  prevMatrix[0][0],
                  prevMatrix[1][0],
                  prevMatrix[2][2],
                  prevMatrix[3][0],
                ]);

                for (int x = 0; x < 4; x++) {
                  subData[x] = substitutionBox(debugging, shifted[x]);
                }

                for (int x = 0; x < 4; x++) {
                  if (x == 0) {
                    xorArr[x] = subData[x] ^ rcon[i - 1];
                    if (debugging == true) {
                      print(
                        "rcon\t: dec :${rcon[i - 1]}\tbit:${rcon[i - 1].toRadixString(2).padLeft(8, '0')}",
                      );
                    }
                  } else {
                    xorArr[x] = subData[x];
                  }
                  if (debugging == true) {
                    print(
                      "sub_data\t: dec:${subData[x]}\tbit:${subData[x].toRadixString(2).padLeft(8, '0')}",
                    );
                  }
                }
                // kolom 5 hanya s box
              } else if (y == 4) {
                for (int x = 0; x < 4; x++) {
                  xorArr[x] = substitutionBox(debugging, prevMatrix[x][y - 1]);
                }
                // kolom selain 1 dan 4
              } else {
                for (int x = 0; x < 4; x++) {
                  xorArr[x] = prevMatrix[x][y - 1];
                }
              }

              // proses xor hasil di taro di prev matrix
              for (int x = 0; x < 4; x++) {
                if (debugging == true) {
                  print(
                    "prev_matrix\t: dec:${prevMatrix[x][y]}\tbit:${prevMatrix[x][y].toRadixString(2).padLeft(8, '0')}",
                  );
                }

                prevMatrix[x][y] = xorArr[x] ^ prevMatrix[x][y];
                if (debugging == true) {
                  print(
                    "xor_arr\t: ${xorArr[x].toRadixString(2).padLeft(8, '0')}",
                  );
                  print(
                    "current\t: dec:${prevMatrix[x][y]}\tbit:${prevMatrix[x][y].toRadixString(2).padLeft(8, '0')}",
                  );
                }
              }
            }

            // pecah prev matrix jadi 2 4x4 matrix
            for (int x = 0; x < 4; x++) {
              matrix1[x] = prevMatrix[x].sublist(0, 4);
              matrix2[x] = prevMatrix[x].sublist(4, 8);
            }
          } else {
            print("Error");
          }
          break;
      }

      rkey.add(matrix1);
      rkey.add(matrix2);
    }

    // Print round keys for debugging
    if (debugging) {
      print("RCON: $rcon");
      for (int index = 0; index < rkey.length; index++) {
        print("\nkey matrix ke : $index");
        for (int i = 0; i < 4; i++) {
          print("${rkey[index][i]}");
        }
      }
    }

    return rkey;
  }

  /// XOR matrix with round key
  static List<List<int>> addRoundKey(List<List<int>> matrix, List<List<int>> key) {
    List<List<int>> result = List.generate(4, (_) => List.filled(4, 0));
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        result[x][y] = matrix[x][y] ^ key[x][y];
      }
    }
    return result;
  }

  /// Inverse S-Box substitution
  static int inverseSbox(bool debugging, int data) {
    List<List<int>> inverseSbox = [
      [
        0x52,
        0x09,
        0x6a,
        0xd5,
        0x30,
        0x36,
        0xa5,
        0x38,
        0xbf,
        0x40,
        0xa3,
        0x9e,
        0x81,
        0xf3,
        0xd7,
        0xfb,
      ],
      [
        0x7c,
        0xe3,
        0x39,
        0x82,
        0x9b,
        0x2f,
        0xff,
        0x87,
        0x34,
        0x8e,
        0x43,
        0x44,
        0xc4,
        0xde,
        0xe9,
        0xcb,
      ],
      [
        0x54,
        0x7b,
        0x94,
        0x32,
        0xa6,
        0xc2,
        0x23,
        0x3d,
        0xee,
        0x4c,
        0x95,
        0x0b,
        0x42,
        0xfa,
        0xc3,
        0x4e,
      ],
      [
        0x08,
        0x2e,
        0xa1,
        0x66,
        0x28,
        0xd9,
        0x24,
        0xb2,
        0x76,
        0x5b,
        0xa2,
        0x49,
        0x6d,
        0x8b,
        0xd1,
        0x25,
      ],
      [
        0x72,
        0xf8,
        0xf6,
        0x64,
        0x86,
        0x68,
        0x98,
        0x16,
        0xd4,
        0xa4,
        0x5c,
        0xcc,
        0x5d,
        0x65,
        0xb6,
        0x92,
      ],
      [
        0x6c,
        0x70,
        0x48,
        0x50,
        0xfd,
        0xed,
        0xb9,
        0xda,
        0x5e,
        0x15,
        0x46,
        0x57,
        0xa7,
        0x8d,
        0x9d,
        0x84,
      ],
      [
        0x90,
        0xd8,
        0xab,
        0x00,
        0x8c,
        0xbc,
        0xd3,
        0x0a,
        0xf7,
        0xe4,
        0x58,
        0x05,
        0xb8,
        0xb3,
        0x45,
        0x06,
      ],
      [
        0xd0,
        0x2c,
        0x1e,
        0x8f,
        0xca,
        0x3f,
        0x0f,
        0x02,
        0xc1,
        0xaf,
        0xbd,
        0x03,
        0x01,
        0x13,
        0x8a,
        0x6b,
      ],
      [
        0x3a,
        0x91,
        0x11,
        0x41,
        0x4f,
        0x67,
        0xdc,
        0xea,
        0x97,
        0xf2,
        0xcf,
        0xce,
        0xf0,
        0xb4,
        0xe6,
        0x73,
      ],
      [
        0x96,
        0xac,
        0x74,
        0x22,
        0xe7,
        0xad,
        0x35,
        0x85,
        0xe2,
        0xf9,
        0x37,
        0xe8,
        0x1c,
        0x75,
        0xdf,
        0x6e,
      ],
      [
        0x47,
        0xf1,
        0x1a,
        0x71,
        0x1d,
        0x29,
        0xc5,
        0x89,
        0x6f,
        0xb7,
        0x62,
        0x0e,
        0xaa,
        0x18,
        0xbe,
        0x1b,
      ],
      [
        0xfc,
        0x56,
        0x3e,
        0x4b,
        0xc6,
        0xd2,
        0x79,
        0x20,
        0x9a,
        0xdb,
        0xc0,
        0xfe,
        0x78,
        0xcd,
        0x5a,
        0xf4,
      ],
      [
        0x1f,
        0xdd,
        0xa8,
        0x33,
        0x88,
        0x07,
        0xc7,
        0x31,
        0xb1,
        0x12,
        0x10,
        0x59,
        0x27,
        0x80,
        0xec,
        0x5f,
      ],
      [
        0x60,
        0x51,
        0x7f,
        0xa9,
        0x19,
        0xb5,
        0x4a,
        0x0d,
        0x2d,
        0xe5,
        0x7a,
        0x9f,
        0x93,
        0xc9,
        0x9c,
        0xef,
      ],
      [
        0xa0,
        0xe0,
        0x3b,
        0x4d,
        0xae,
        0x2a,
        0xf5,
        0xb0,
        0xc8,
        0xeb,
        0xbb,
        0x3c,
        0x83,
        0x53,
        0x99,
        0x61,
      ],
      [
        0x17,
        0x2b,
        0x04,
        0x7e,
        0xba,
        0x77,
        0xd6,
        0x26,
        0xe1,
        0x69,
        0x14,
        0x63,
        0x55,
        0x21,
        0x0c,
        0x7d,
      ],
    ];

    // kolom / col / x
    int mod16 = data % 16;
    // baris / row / y
    int base16 = (data - mod16) ~/ 16;
    // ambil data substitution box
    int subData = inverseSbox[base16][mod16];

    if (debugging == true) {
      print("orgin\t\t:hex:${data.toRadixString(16)}\t: dec:$data");
      print("baris\t\t:${base16.toRadixString(16)}");
      print("kolom\t\t:${mod16.toRadixString(16)}");
      print("sub data\t:${subData.toRadixString(16)}");
    }
    return subData;
  }

  /// Inverse shift rows operation
  static List<List<int>> inverseShiftRows(List<List<int>> matrix) {
    List<List<int>> result = List.generate(4, (_) => List.filled(4, 0));
    for (int x = 0; x < 4; x++) {
      List<int> a = matrix[x].sublist(0, 4 - x);
      List<int> b = matrix[x].sublist(4 - x);
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

  /// Galois Field multiplication for GF(2^8)
  static int _gf258(int x, int y) {
    int p = 0x11B;
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

  /// Inverse mix columns operation
  static List<List<int>> inverseMixColumns(bool debugging, List<List<int>> matrix) {
    List<List<int>> result = List.generate(4, (_) => List.filled(4, 0));

    List<List<int>> inverseMatrixMultiplication = [
      [0x0E, 0x0B, 0x0D, 0x09],
      [0x09, 0x0E, 0x0B, 0x0D],
      [0x0D, 0x09, 0x0E, 0x0B],
      [0x0B, 0x0D, 0x09, 0x0E],
    ];

    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        for (int z = 0; z < 4; z++) {
          int gf = _gf258(inverseMatrixMultiplication[x][z], matrix[z][y]);
          int res = result[x][y] ^ gf;
          if (debugging == true) {
            print(
              "________________________________________________________________________",
            );
            print(
              "matrix[$x][$z]\t\t\t:${matrix[x][z].toRadixString(2).padLeft(8, '0')} ${matrix[x][z].toRadixString(16)}",
            );
            print(
              "inverse_matrix_multiplication[$z][$y]\t:${inverseMatrixMultiplication[z][y].toRadixString(2).padLeft(8, '0')} ${inverseMatrixMultiplication[z][y].toRadixString(16)}",
            );
            print("gf258\t\t\t\t:${gf.toRadixString(2).padLeft(8, '0')}");
            print(
              "awal[$x][$y]\t\t\t:${result[x][y].toRadixString(2).padLeft(8, '0')}",
            );
            print("xor\t\t\t\t:${res.toRadixString(2).padLeft(8, '0')}");
          }
          result[x][y] = res;
          if (debugging == true) {
            print(
              "stored[$x][$y]\t\t\t:${result[x][y].toRadixString(2).padLeft(8, '0')}",
            );
          }
        }
      }
    }
    return result;
  }

  /// Main decryption process for a single 4x4 matrix
  static List<List<int>> decryption(
      bool debugging,
      List<List<int>> matrix,
      List<List<List<int>>> rkeys,
      ) {
    // Initial add_round_key
    matrix = addRoundKey(matrix, rkeys[0]);

    // 13 main rounds
    for (int i = 1; i < (rkeys.length - 1); i++) {
      // Inverse ShiftRows
      matrix = inverseShiftRows(matrix);
      // Inverse SubBytes
      for (int x = 0; x < 4; x++) {
        for (int y = 0; y < 4; y++) {
          matrix[x][y] = inverseSbox(debugging, matrix[x][y]);
        }
      }
      // AddRoundKey
      matrix = addRoundKey(matrix, rkeys[i]);
      // Inverse MixColumns
      matrix = inverseMixColumns(debugging, matrix);
    }

    // Final round (no Inverse MixColumns)
    matrix = inverseShiftRows(matrix);
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        matrix[x][y] = inverseSbox(debugging, matrix[x][y]);
      }
    }
    matrix = addRoundKey(matrix, rkeys[rkeys.length - 1]);
    return matrix;
  }
}

// Example usage class for Flutter Cubit
class AesDecryptionExample {
  /// Example method showing how to use the utility
  static List<String> decryptExample() {
    String key = "12345678123456781234567812345678";
    String ciphertextJson = '''
    [
      [
        [
          [70, 80, 93, 131], 
          [209, 202, 246, 198], 
          [241, 172, 85, 29], 
          [29, 124, 242, 46]
        ], 
        [
          [67, 251, 158, 127], 
          [128, 205, 26, 200], 
          [121, 131, 74, 141], 
          [239, 30, 115, 150]
        ], 
        [
          [120, 58, 104, 49], 
          [205, 245, 224, 195], 
          [90, 240, 203, 209], 
          [133, 207, 34, 159]
        ]
      ]
    ]
    ''';

    try {
      var ciphertext = AesDecryptionUtil.parseCiphertext(ciphertextJson);
      return AesDecryptionUtil.decrypt(key, ciphertext);
    } catch (e) {
      print("Decryption error: $e");
      return [];
    }
  }
}