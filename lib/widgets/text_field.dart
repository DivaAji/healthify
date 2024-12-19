import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final double height;
  final TextInputType keyboardType;
  final TextEditingController?
      controller; // Controller dideklarasikan di widget
  final bool isError;
  final String? validationText;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.height = 50.0,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.isError = false,
    this.validationText,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;
  final FocusNode _focusNode =
      FocusNode(); // Fokus untuk mendeteksi status fokus
  bool _isFocused = false; // Status apakah TextField sedang fokus

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;

    // Listener untuk mendeteksi perubahan fokus
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Jangan lupa untuk dispose FocusNode
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured; // Toggle status visibilitas password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  border: Border.all(
                    color: widget.isError
                        ? Colors.red // Warna merah jika ada error
                        : const Color(0xFF78B9BA), // Warna default
                  ),
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
                  focusNode: _focusNode, // Tambahkan FocusNode
                  controller: widget.controller,
                  obscureText: _isObscured,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: widget.labelText,
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 87, 97, 112),
                    ),
                    suffixIcon: widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF21324B),
                            ),
                            onPressed: _toggleObscureText,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isFocused &&
            widget.validationText !=
                null) // Tampilkan validasi hanya saat fokus
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              widget.validationText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
