import 'package:flutter/material.dart';

import 'mo_form.dart';

import 'package:flutter/material.dart';

import 'mo_form.dart';

class MoSelectableFormWidget<T> extends StatefulWidget {
  final String? title;
  final bool isPassword;
  final bool isDropdown;
  final Icon? prefixIcon;
  final String? hintText;
  final List<T>? items;
  final ValueChanged<T>? onItemSelected;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final T? initialValue;

  const MoSelectableFormWidget({
    Key? key,
    this.title,
    this.isPassword = false,
    this.isDropdown = false,
    this.prefixIcon,
    this.hintText,
    this.items,
    this.onItemSelected,
    this.itemBuilder,
    this.initialValue,
  }) : super(key: key);

  @override
  _MoSelectableFormWidgetState<T> createState() =>
      _MoSelectableFormWidgetState<T>();
}

class _MoSelectableFormWidgetState<T> extends State<MoSelectableFormWidget<T>> {
  bool _obscureText = true;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _selectedValueController = TextEditingController();
  List<T>? _filteredItems;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue;
      _selectedValueController.text = _selectedItem.toString();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _selectedValueController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 8,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MoFormWidget(
                controller: _searchController,
                keyboardType: TextInputType.text,
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey,),
                title: "",
                onChange: (query) {
                  setState(() {
                    _filteredItems = widget.items
                        ?.where((item) => item.toString().toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = _filteredItems![index];
                  return GestureDetector(
                    onTap: () {
                      widget.onItemSelected?.call(item);
                      setState(() {
                        _selectedItem = item;
                        _selectedValueController.text = item.toString();
                      });
                      Navigator.pop(context);
                    },
                    child: widget.itemBuilder!(context, item),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            const SizedBox(height: 20),
            Text(
              widget.title!,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
          ],
          GestureDetector(
            onTap: widget.isDropdown ? _showBottomSheet : null,
            child: AbsorbPointer(
              absorbing: widget.isDropdown,
              child: TextFormField(
                controller: widget.isDropdown ? _selectedValueController : null,
                obscureText: widget.isPassword ? _obscureText : false,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
