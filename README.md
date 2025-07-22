# 📚 Aplikasi TU – Monitoring Pembayaran SPP Orang Tua / Wali Murid

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-%23FF2D20.svg?style=for-the-badge&logo=laravel&logoColor=white)

> **Aplikasi TU** adalah aplikasi mobile berbasis Flutter yang digunakan oleh orang tua atau wali murid untuk memantau status pembayaran SPP siswa, termasuk yang belum lunas, menunggu verifikasi, dan sudah lunas. Aplikasi ini juga menyediakan fitur cetak struk pembayaran.

---

## 🎯 Tujuan Proyek

Proyek ini dibuat sebagai bagian dari **Kuliah Kerja Praktek** dan juga sebagai media pembelajaran praktis dalam mengembangkan aplikasi mobile terpadu yang menggunakan enkripsi dan API modern.

---

## ✨ Fitur Utama

- 🔍 Lihat daftar tagihan SPP siswa
- ✅ Mengetahui status pembayaran: **Belum Lunas**, **Menunggu Verifikasi**, **Sudah Lunas**
- 📤 Upload bukti pembayaran
- 🧾 Cetak struk pembayaran langsung dari aplikasi
- 🔐 Enkripsi menggunakan **Rust FFI**
- 📡 Terintegrasi dengan API backend berbasis **Laravel**

---

## 🧩 Teknologi yang Digunakan

| Teknologi     | Keterangan                                |
|---------------|--------------------------------------------|
| Flutter       | UI Aplikasi Mobile                        |
| Laravel (API) | Backend untuk transaksi dan autentikasi   |
| Rust (FFI)    | Enkripsi data sensitif secara native      |

> Catatan: API Laravel tidak termasuk dalam repositori ini.

---

## 📦 Struktur Folder

Aplikasi-TU/
│
├── assets/ # Gambar dan ikon statis
├── lib/ # Source code utama aplikasi
│ ├── encryption/ # Binding FFI untuk Rust
│ ├── models/ # Model data aplikasi
│ ├── screens/ # Tampilan halaman
│ ├── services/ # Koneksi ke API
│ ├── widgets/ # Komponen UI kustom
├── pubspec.yaml # Dependensi Flutter
└── README.md # Dokumentasi ini

---

## 🚀 Instalasi dan Menjalankan Aplikasi

### Prasyarat

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code
- Rust toolchain (untuk compile modul enkripsi)
- Android device atau emulator

### Langkah-langkah:

1. **Clone repository ini**

```bash
git clone https://github.com/Nievys/Aplikasi-TU.git
cd Aplikasi-TU
```

2. **Install dependencies flutter**

```bash
flutter pub get
```

3. **Build Rust FFI (opsional jika belum dibuild)**

```bash
cd rust_encryption/
cargo build --release
```
  Lalu hasil compile (.so, .dll, atau .dylib) digunakan oleh Flutter melalui FFI.

4. **Jalankan aplikasi**

```bash
flutter run
```

## 🧠 Kredit dan Referensi
Aplikasi ini dikembangkan sebagai bagian dari Kuliah Kerja Praktek oleh mahasiswa informatika dengan tujuan edukatif dan kontribusi publik.
