import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/login/login_screen.dart'; // Make sure to update this path if needed

class EditProfilScreen extends StatefulWidget {
  final String username;
  final String email;
  final String height;
  final String weight;
  final String gender;
  final String profileImagePath;
  final String ageRange;

  const EditProfilScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.gender,
    required this.profileImagePath,
    required this.ageRange,
  }) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  // Controllers for each field to manage the form inputs
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values from the widget's passed parameters
    _usernameController.text = widget.username;
    _emailController.text = widget.email;
    _heightController.text = widget.height;
    _weightController.text = widget.weight;
    _genderController.text = widget.gender;
    _ageRangeController.text = widget.ageRange;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _ageRangeController.dispose();
    super.dispose();
  }

  // Function to save the updated profile data (you can modify this to save to API or SharedPreferences)
  Future<void> _saveProfileData() async {
    // You can implement saving here (e.g., update API, save to SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('height', _heightController.text);
    await prefs.setString('weight', _weightController.text);
    await prefs.setString('gender', _genderController.text);
    await prefs.setString('age_range', _ageRangeController.text);

    // Show a confirmation message after saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  // Function to logout
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove saved token

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture (Just showing the current one, with no option to change)
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.profileImagePath.startsWith('http')
                  ? NetworkImage(widget.profileImagePath)
                  : AssetImage(widget.profileImagePath) as ImageProvider,
            ),
            const SizedBox(height: 16),

            // Editable fields for each piece of profile information
            _buildTextField('Username', _usernameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Height (cm)', _heightController),
            _buildTextField('Weight (kg)', _weightController),
            _buildTextField('Gender', _genderController),
            _buildTextField('Age Range', _ageRangeController),

            const SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: _saveProfileData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
