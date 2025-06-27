import 'package:flutter/material.dart';

// Widget personalizado que actúa como un campo de texto desplegable
class DropdownTextField extends StatefulWidget {
  final String?
  hintText; // Texto de sugerencia cuando no se ha seleccionado nada
  final List<String>
  options; // Lista de opciones que se mostrarán en el dropdown
  final String? selectedValue; // Valor actualmente seleccionado
  final ValueChanged<String?>?
  onChanged; // Callback que se ejecuta al cambiar el valor
  final bool enabled; // Determina si el campo está habilitado o deshabilitado

  const DropdownTextField({
    super.key,
    this.hintText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.enabled = true,
  });

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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Seleccionar opción',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: widget.enabled
              ? Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                  size: 20.0,
                )
              : Icon(Icons.close, color: Colors.grey.shade600, size: 16.0),
        ),
        icon: const SizedBox.shrink(), // Ocultar el ícono por defecto
        style: const TextStyle(color: Colors.black87, fontSize: 14.0),
        dropdownColor: Colors.white,
        items: widget.options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: widget.enabled
            ? (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              }
            : null,
        isExpanded: true,
      ),
    );
  }
}
