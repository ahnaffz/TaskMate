import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:intl/intl.dart'; // Untuk format tanggal

// Import widget lain
import '../widgets/sidebar.dart';
import '../../tasks/screens/add_task_screen.dart'; 
import '../../tasks/models/task_model.dart';       
import '../../tasks/screens/task_detail_screen.dart'; 

class HomePageGrid extends StatefulWidget {
  const HomePageGrid({super.key});

  @override
  State<HomePageGrid> createState() => _HomePageGridState();
}

class _HomePageGridState extends State<HomePageGrid> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Variabel untuk menyimpan filter yang sedang aktif (Default: Tampilkan Semua)
  String _currentFilter = 'All';  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA), // Warna background abu-abu muda
      drawer: const AppSidebar(), // Memanggil Sidebar yang kita buat di atas
      
      appBar: AppBar(
        // ... (Kode AppBar standar: Judul, Warna Putih, dll)
        actions: [
          // --- MENU TITIK TIGA (PopUp Menu) ---
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) async {
              if (value == 'hapus_selesai') {
                // LOGIKA HAPUS: Mencari semua tugas yang 'isDone' == true lalu menghapusnya
                final batch = FirebaseFirestore.instance.batch(); // Pakai batch agar efisien
                var collection = FirebaseFirestore.instance.collection('tasks');
                var snapshots = await collection.where('isDone', isEqualTo: true).get();
                for (var doc in snapshots.docs) {
                  batch.delete(doc.reference); // Tandai untuk dihapus
                }
                await batch.commit(); // Eksekusi hapus
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tugas selesai berhasil dihapus")));
                }
              } else {
                // LOGIKA FILTER: Jika user memilih menu lain, ubah nilai _currentFilter
                setState(() {
                  _currentFilter = value;
                });
              }
            },
            // Daftar Menu Titik Tiga
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'dibintangi', child: Text("Dibintangi")),
              const PopupMenuItem(value: 'belum_selesai', child: Text("Belum Selesai")),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'hapus_selesai', child: Text("Hapus yang Selesai", style: TextStyle(color: Colors.red))),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'All', child: Text("Tampilkan semua", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),

      // --- STREAM BUILDER: Jantungnya Real-time Data ---
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil data dari koleksi 'tasks', diurutkan dari yang terbaru
        stream: FirebaseFirestore.instance.collection('tasks').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          // Tampilkan loading jika data belum siap
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          // Ambil semua dokumen tugas
          final allDocs = snapshot.data?.docs ?? [];

          // FUNGSI PENGAMAN: Mencegah error jika ada data lama yang tidak punya kategori
          String getCategory(QueryDocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['category'] ?? 'General'; // Kalau null, anggap 'General'
          }

          // --- LOGIKA HITUNG JUMLAH KARTU (REAL-TIME) ---
          // Menghitung berapa banyak tugas untuk masing-masing kategori
          final int personalCount = allDocs.where((doc) => getCategory(doc) == 'Personal').length;
          final int workCount = allDocs.where((doc) => getCategory(doc) == 'Work').length;
          final int privateCount = allDocs.where((doc) => getCategory(doc) == 'Private').length;
          final int healthCount = allDocs.where((doc) => getCategory(doc) == 'Health').length;

          // --- LOGIKA FILTERING LIST BAWAH ---
          // Menentukan tugas mana yang boleh tampil di list berdasarkan _currentFilter
          var displayDocs = allDocs;
          if (_currentFilter == 'dibintangi') {
             displayDocs = allDocs.where((doc) => (doc.data() as Map)['isStarred'] == true).toList();
          } else if (_currentFilter == 'belum_selesai') {
             displayDocs = allDocs.where((doc) => (doc.data() as Map)['isDone'] == false).toList();
          } else if (_currentFilter != 'All') {
             // Filter berdasarkan kategori (misal user klik kartu 'Work')
             displayDocs = allDocs.where((doc) => getCategory(doc) == _currentFilter).toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                const Text("My Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E255E))),
                const SizedBox(height: 15),
                
                // --- GRID KARTU BERWARNA ---
                GridView.count(
                  shrinkWrap: true, // Agar tidak error scroll
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, // 2 Kolom
                  children: [
                    // Memasukkan variabel count hasil hitungan tadi ke sini
                    _buildGridItem("Personal", "$personalCount Tasks", Icons.person, Colors.blue, const Color(0xFFEBEBFF)),
                    _buildGridItem("Work", "$workCount Tasks", Icons.work, Colors.orange, const Color(0xFFFFF4E5)),
                    _buildGridItem("Private", "$privateCount Tasks", Icons.lock, Colors.red, const Color(0xFFFDEBF1)),
                    _buildGridItem("Health", "$healthCount Tasks", Icons.favorite, Colors.green, const Color(0xFFE5F9EB)),
                  ],
                ),

                const SizedBox(height: 30),

                // --- LIST TUGAS (ALL TASKS) ---
                // ... (Judul All Tasks) ...
                
                // Menampilkan daftar tugas yang sudah difilter
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayDocs.length,
                  itemBuilder: (context, index) {
                    final doc = displayDocs[index]; // Ambil 1 data tugas
                    final data = doc.data() as Map<String, dynamic>;
                    final docId = doc.id; // ID unik dokumen untuk update/delete

                    return Card(
                      child: ListTile(
                        // Navigasi ke Detail Task saat diklik
                        onTap: () {
                           // Bungkus data jadi Object Task dan kirim ke layar Detail
                           Task taskObj = Task(/* ... isi data ... */);
                           Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: taskObj)));
                        },
                        // Checkbox untuk menandai selesai
                        leading: Checkbox(
                          value: data['isDone'] ?? false,
                          onChanged: (bool? value) {
                            // Update langsung ke Firebase
                            FirebaseFirestore.instance.collection('tasks').doc(docId).update({'isDone': value});
                          },
                        ),
                        title: Text(data['title'] ?? 'Tanpa Judul'),
                        // ...
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      // (Tombol Tambah dihapus sesuai request Anda)
    );
  }
  // ... (Widget _buildGridItem helper) ...
}
