import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double height;
  final TextEditingController?
      controller; // Pastikan controller dideklarasikan di widget

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.height = 50.0,
    this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText; // Inisialisasi sesuai nilai `obscureText`
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured; // Toggle status visibilitas password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: TextField(
        controller: widget.controller, // Gunakan controller dari widget
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscureText,
                )
              : null, // Tampilkan ikon hanya jika `obscureText` true
        ),
      ),
    );
  }
}
