import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double height;
  final TextInputType keyboardType;
  final TextEditingController?
<<<<<<< HEAD
      controller;
  final IconButton? suffixIcon; // Pastikan controller dideklarasikan di widget
=======
      controller; // Controller dideklarasikan di widget
>>>>>>> 1642cb71365a0d58944cbe2ca86b0e29bbe34b9e

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.height = 50.0,
<<<<<<< HEAD
    this.controller, 
    this.suffixIcon,
=======
    this.keyboardType = TextInputType.text,
    this.controller,
>>>>>>> 1642cb71365a0d58944cbe2ca86b0e29bbe34b9e
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured; // Toggle status visibilitas password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.height, // Tetapkan batasan tinggi maksimum
      ),
      child: Stack(
        children: [
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF78B9BA)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: TextField(
              controller: widget.controller,
              obscureText: _isObscured,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.labelText,
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 87, 97, 112)),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF21324B),
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
