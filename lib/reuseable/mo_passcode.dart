import 'package:flutter/material.dart';

class DynamicPasscodeForm extends StatefulWidget {
  final String title;
  final int passcodeLength;
  final Function(String) onPasscodeEntered;

  const DynamicPasscodeForm({
    super.key,
    required this.title,
    this.passcodeLength = 6, required this.onPasscodeEntered,
  });

  @override
  _DynamicPasscodeFormState createState() => _DynamicPasscodeFormState();
}

class _DynamicPasscodeFormState extends State<DynamicPasscodeForm> {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.passcodeLength, (index) => TextEditingController());
    _focusNodes = List.generate(widget.passcodeLength, (index) => FocusNode());

    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onPasscodeChanged() {
    String passcode = _controllers.map((controller) => controller.text).join();
    if (passcode.length == widget.passcodeLength) {
      widget.onPasscodeEntered(passcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.passcodeLength,
                  (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    obscureText: true,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
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
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty && index < widget.passcodeLength - 1) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          _controllers[index].clear();
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                      });
                      _onPasscodeChanged();
                    },
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
