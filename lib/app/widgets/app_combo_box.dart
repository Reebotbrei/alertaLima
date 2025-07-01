import 'package:flutter/material.dart';

class DropdownTextField extends StatefulWidget {
  final String? hintText;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const DropdownTextField({
    Key? key,
    this.hintText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Esto hace que ocupe todo el ancho disponible
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 3.0,
      ), // Altura más pequeña
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedValue,
          hint: Text(
            widget.hintText ?? 'Seleccionar opción',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.0),
          ),
          icon: widget.enabled
              ? Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600)
              : Icon(Icons.close, color: Colors.grey.shade600, size: 16.0),
          style: const TextStyle(color: Colors.black87, fontSize: 14.0),
          dropdownColor: Colors.white,
          menuMaxHeight:
              MediaQuery.of(context).size.height *
              0.4, // Reducido para evitar overflow
          elevation: 8,
          borderRadius: BorderRadius.circular(8.0),
          alignment: AlignmentDirectional
              .centerStart, // Alineación para evitar overflow
          items: widget.options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ),
            );
          }).toList(),
          onChanged: widget.enabled
              ? (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                  widget.onChanged?.call(newValue);
                }
              : null,
          isExpanded: true,
          isDense: false, // Mantiene el espaciado natural
        ),
      ),
    );
  }
}
