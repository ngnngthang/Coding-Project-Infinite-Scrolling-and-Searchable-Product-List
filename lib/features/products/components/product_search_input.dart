import 'package:flutter/material.dart';
import 'package:infinite_list_and_search/components/inputs/text_input.dart';

class ProductSearchInput extends StatefulWidget {
  const ProductSearchInput({super.key, this.onChanged, this.onClearText});

  final Function(String)? onChanged;
  final VoidCallback? onClearText;

  @override
  State<ProductSearchInput> createState() => _ProductSearchInputState();
}

class _ProductSearchInputState extends State<ProductSearchInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    setState(() {});
  }

  void _clearText() {
    _controller.clear();
    widget.onClearText?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: _controller,
      hintText: 'Search products...',
      onChanged: _onChanged,
      prefix: Icon(Icons.search, size: 20, color: Colors.black87),
      suffix: _controller.text.isNotEmpty
          ? IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              onPressed: _clearText,
              icon: Icon(Icons.clear, size: 20, color: Colors.black87),
            )
          : null,
    );
  }
}
