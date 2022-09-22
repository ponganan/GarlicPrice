import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog(this.link, {Key? key}) : super(key: key);
  final String? link;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.network(
        link!,
        width: 800,
        height: 600,
        fit: BoxFit.cover,
      ),
    );
  }
}
