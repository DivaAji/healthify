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
        'tanggal': '2024-11-20', // Menambahkan tanggal ke setiap latihan
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = _selectedDate.add(Duration(days: index - _selectedDate.weekday));
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Column(
                    children: [
                      Text(
                        ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][date.weekday % 7],
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${date.day}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (_selectedDate.day == date.day && _selectedDate.month == date.month && _selectedDate.year == date.year)
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
          Expanded(
            child: latihanProgram.containsKey(_selectedDate)
                ? ListView.builder(
                    itemCount: latihanProgram[_selectedDate]!.length,
                    itemBuilder: (context, index) {
                      final program = latihanProgram[_selectedDate]![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                                  // Text(
                                  //   'Tanggal: ${program['tanggal']}',
                                  //   style: const TextStyle(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
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
