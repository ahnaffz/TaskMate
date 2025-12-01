# TaskMate App 📝

Aplikasi manajemen tugas produktif untuk membantu mahasiswa dan profesional mengatur jadwal harian. Dibuat dengan Flutter, Riverpod, dan Firebase.

## 🚀 Cara Menjalankan Proyek (Setup)

Ikuti langkah ini untuk menjalankan aplikasi di komputer Anda:

### 1. Clone Repository
Unduh source code proyek ini ke komputer Anda:

```
git clone https://github.com/ahnaffz/TaskMate.git
cd taskmate_app
```

### 2. Install Dependencies
Unduh semua library yang dibutuhkan aplikasi:

```
flutter pub get
```

### 3. Konfigurasi Firebase (WAJIB)
Langkah ini menghubungkan aplikasi ke database Anda:

1. Pastikan FlutterFire CLI sudah terinstall.

2. Jalankan perintah ini di terminal:

```
flutterfire configure
```

3. Pilih project Firebase yang Anda gunakan di console.

4. Ini akan membuat/memperbarui file konfigurasi yang sesuai dengan mesin Anda secara otomatis.

### 4. Jalankan Aplikasi
Pastikan emulator atau device fisik sudah terhubung, lalu jalankan:

```
flutter run
```