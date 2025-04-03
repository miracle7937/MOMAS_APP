import 'package:flutter/material.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/utils/colors.dart';

class RatingModal extends StatefulWidget {
  final Function(int, String) onSubmit;

  const RatingModal({super.key, required this.onSubmit});

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Rating',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Rating',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return  InkWell(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    size: 30,
                    ),
                )
                ;
              }),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(thickness: 1, color: Colors.grey,),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                hintText: 'Comment',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:  BorderSide(color: MoColors.mainColor),
                ),
              ),
              maxLines: 4,
            )
            ,
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MoButton(
                  title: 'ADD COMMENT',
                  onTap: () {
                    widget.onSubmit(_rating, _commentController.text);
                    Navigator.of(context).pop();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
