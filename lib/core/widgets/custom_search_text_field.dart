import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textDirection: Directionality.of(context),
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
            onPressed: _clearSearch,
            icon: const Icon(Icons.close),
            tooltip: 'Clear',
          )
              : null,
        ),
      ),
    );
  }
}