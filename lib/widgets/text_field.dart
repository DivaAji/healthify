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
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang putih
        borderRadius: BorderRadius.circular(20), // Radius sudut 20
        border: Border.all(
            color: const Color(0xFF78B9BA)), // Garis tepi berwarna hitam
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Warna bayangan
            spreadRadius: 1, // Radius penyebaran bayangan
            blurRadius: 4, // Blur radius bayangan
            offset: Offset(0, 4), // Posisi bayangan (x, y)
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller, // Gunakan controller dari widget
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: InputBorder.none, // Menghilangkan border default
          labelText: widget.labelText,
          labelStyle: TextStyle(color: const Color(0xFF21324B)), // Warna label
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF21324B), // Warna ikon
                  ),
                  onPressed: _toggleObscureText,
                )
              : null, // Hanya tampilkan ikon mata jika `obscureText` true
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16), // Padding konten
        ),
      ),
    );
  }
}
