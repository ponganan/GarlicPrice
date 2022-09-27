import 'package:flutter/material.dart';

class ShowAvatarPage extends StatelessWidget {
  const ShowAvatarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blue,
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/garlic-price.appspot.com/o/profilePicture%2Fpost_1664245968120?alt=media&token=087544a0-7ef9-47cb-91e3-79164ca6cffe'),
          radius: 20,
        ),
      ),
    );
  }
}
