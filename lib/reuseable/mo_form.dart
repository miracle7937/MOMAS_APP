import 'package:flutter/material.dart';

import '../utils/strings.dart';

class MoFormWidget extends StatefulWidget {
  final String? title;
  final bool isPassword;
  final bool? enable;
  final Icon? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChange;

  const MoFormWidget({
    super.key,
     this.title,
    this.controller,
    this.isPassword = false, this.prefixIcon, this.hintText, this.keyboardType, this.onChange,
     this.enable,
  });

  @override
  _MoFormWidgetState createState() => _MoFormWidgetState();
}

class _MoFormWidgetState extends State<MoFormWidget> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      isNotEmpty(widget.title)? Column(
         children: [
           const SizedBox(height: 20,),
           Text(widget.title ?? "", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),),
           const SizedBox(height: 10,),
         ],
       ): Container(),
          TextFormField(
            enabled: widget.enable,
            onChanged: widget.onChange,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              ) : null,
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

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              )
            ),
          ),
        ],
      ),
    );
  }
}
