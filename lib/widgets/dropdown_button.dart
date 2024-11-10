import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String labelText;
  final String selectedValue;
  final List<String> items;
  final Function(String?) onChanged;
  final double height;

  const CustomDropdownButton({
    Key? key,
    required this.labelText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: height,
      ),
      child: Container(
        height: height,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                selectedValue.isEmpty ? labelText : selectedValue,
                style: TextStyle(
                  color: selectedValue.isEmpty
                      ? const Color.fromARGB(255, 87, 97, 112)
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {
                showDropdownMenu(context);
              },
              color: const Color(0xFF21324B),
            ),
          ],
        ),
      ),
    );
  }

  void showDropdownMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset =
        renderBox.localToGlobal(Offset.zero); // Mendapatkan posisi tombol

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy +
            renderBox.size.height, // Posisi dropdown berada di bawah tombol
        offset.dx + renderBox.size.width,
        0,
      ),
      color: Colors.white,
      items: items
          .map(
            (item) => PopupMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
    ).then((value) {
      if (value != null) {
        onChanged(value);
      }
    });
  }
}
