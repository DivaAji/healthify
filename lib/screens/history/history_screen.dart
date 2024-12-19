import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({Key? key}) : super(key: key);

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = false;
  String? _userId;
  List<Map<String, dynamic>> _categories = [];

  // Fetch workout history
  Future<List<Map<String, dynamic>>> fetchWorkoutHistory(
      String userId, String date) async {
    final url = ApiConfig.workoutHistoryEndpoint(userId, date);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load workout history');
    }
  }

  Future<void> _fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String date =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}"; // Date yang dipilih

    if (userId != null) {
      final url = ApiConfig.workoutHistoryEndpoint(userId, date);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if data is a list
        if (data is List) {
          // Group data by category
          Map<String, List<Map<String, dynamic>>> groupedWorkouts = {};

          for (var workout in data) {
            String category = workout['category'];

            if (groupedWorkouts[category] == null) {
              groupedWorkouts[category] = [];
            }

            groupedWorkouts[category]?.add({
              'name': workout['name'],
              'sub_category': workout['sub_category'],
              'description': workout['description'],
              'duration': workout['duration'],
              'workouts_id': workout['workouts_id'],
              'date': workout['date'],
            });
          }

          // Update the state with grouped workouts
          if (mounted) {
            setState(() {
              _categories = groupedWorkouts.entries.map((entry) {
                return {
                  'category': entry.key,
                  'workouts': entry.value,
                };
              }).toList();
            });
          }
        } else {
          throw Exception('Gagal memuat histori latihan');
        }
      } else {
        throw Exception('Gagal memuat histori latihan');
      }
    }
  }

  Future<void> _fetchData() async {
    if (_userId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Memanggil API untuk mendapatkan data berdasarkan tanggal yang dipilih
      final data = await fetchWorkoutHistory(
        _userId!,
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
      );

      // Pastikan data yang diterima sesuai dengan tanggal yang dipilih
      final filteredData = data.where((workout) {
        final workoutDate = DateTime.parse(workout['date']);
        return workoutDate.year == _selectedDate.year &&
            workoutDate.month == _selectedDate.month &&
            workoutDate.day == _selectedDate.day;
      }).toList();

      if (mounted) {
        setState(() {
          _historyData = filteredData;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id');
    });
    _fetchData();
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchCategories(); // Fetch categories on init
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _categories.clear();
      });
      _fetchData();
      _fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout History',
          style: TextStyle(color: Color(0xFF21324B)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade200, // Set to grey shade 200
        foregroundColor: Color(0xFF21324B),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Left padding
            child: Text(
              'Pilih Tanggal', // Add "Pilih Tanggal" text
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF21324B),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: SafeArea(
        // Wrap the body with SafeArea to prevent overlap with AppBar
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Display workout history grouped by category
                    Expanded(
                      child: _categories.isEmpty
                          ? const Center(
                              child: Text('Tidak ada histori latihan.'))
                          : ListView(
                              children: _categories.map((categoryData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      color: Colors
                                          .grey.shade50, // Set to grey shade 50
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          categoryData['category'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(
                                                0xFF008B90), // Red color for category
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...categoryData['workouts'].map((program) {
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        elevation: 2,
                                        color: Colors.white,
                                        child: ListTile(
                                          title: Text(program['name']),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Duration: ${program['duration']}'),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Sub Category: ${program['sub_category']}'),
                                              SizedBox(height: 5),
                                              Text(
                                                'Description: ${program['description']}',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          isThreeLine: true,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
