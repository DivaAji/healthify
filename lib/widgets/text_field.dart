import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double height;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.height = 50.0,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured =
        widget.obscureText; // Mulai dengan status sesuai nilai `obscureText`
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
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.labelText,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscureText,
                )
              : null, // Hanya tampilkan ikon mata jika `obscureText` true
        ),
      ),
    );
  }
}
