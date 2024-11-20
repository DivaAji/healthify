import 'package:flutter/material.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({super.key});

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  DateTime _selectedDate = DateTime.now();

  // Contoh data program latihan yang sudah terstruktur dengan tanggal
  Map<DateTime, List<Map<String, String>>> latihanProgram = {
    DateTime(2024, 11, 20): [
      {
        'tanggal': '2024-11-20',
        'kategori': 'Kelincahan',
        'step': 'Lari tempat',
        'durasi': '1 menit',
        'image': 'assets/images/kelenturan.jpg'
      },
      {
        'tanggal': '2024-11-20',
        'kategori': 'Kelincahan',
        'step': 'Skipping',
        'durasi': '1 menit',
        'image': 'assets/images/kelenturan.jpg'
      },
      {
        'tanggal': '2024-11-20',
        'kategori': 'Kelenturan',
        'step': 'Peregangan kaki & punggung',
        'durasi': '2 menit',
        'image': 'assets/images/kelenturan.jpg'
      },
    ],
    DateTime(2024, 11, 21): [
      {
        'tanggal': '2024-11-21',
        'kategori': 'Kelenturan',
        'step': 'Peregangan leher & bahu',
        'durasi': '2 menit',
        'image': 'assets/images/kelenturan.jpg'
      },
      {
        'tanggal': '2024-11-21',
        'kategori': 'Kelincahan',
        'step': 'Lari zig-zag',
        'durasi': '2 menit',
        'image': 'assets/images/kelenturan.jpg'
      },
    ],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(
                  0, 139, 144, 1), // Warna utama (header dan tombol)
              onPrimary: Colors.white, // Warna teks pada header
              onSurface: const Color.fromARGB(
                  255, 45, 45, 45), // Warna teks pada kalender
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color.fromRGBO(0, 139, 144, 1), // Warna tombol
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
            tooltip: 'Pilih Tanggal',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft, // Rata kiri
              child: Text(
                'Minggu Ini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(33, 50, 75, 1),
                ),
              ),
            ),
          ),

          // Komponen Mingguan
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = _selectedDate
                    .add(Duration(days: index - _selectedDate.weekday));
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Column(
                    children: [
                      Text(
                        [
                          'SUN',
                          'MON',
                          'TUE',
                          'WED',
                          'THU',
                          'FRI',
                          'SAT'
                        ][date.weekday % 7],
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${date.day}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (_selectedDate.day == date.day &&
                          _selectedDate.month == date.month &&
                          _selectedDate.year == date.year)
                        Container(
                          height: 2,
                          width: 20,
                          color: Colors.black,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Daftar History Latihan
          Expanded(
            child: latihanProgram.containsKey(DateTime(
                    _selectedDate.year, _selectedDate.month, _selectedDate.day))
                ? ListView.builder(
                    itemCount: latihanProgram[DateTime(_selectedDate.year,
                            _selectedDate.month, _selectedDate.day)]!
                        .length,
                    itemBuilder: (context, index) {
                      final program = latihanProgram[DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day)]![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                program['image']!,
                                height: 72,
                                width: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program['step']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    program['durasi']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Tidak ada latihan di tanggal ini',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
