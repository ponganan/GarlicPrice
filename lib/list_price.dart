import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/model/list_price_model.dart';
import 'package:garlic_price/model/format_datetime.dart';

class ListPrice extends StatefulWidget {
  const ListPrice({Key? key}) : super(key: key);

  @override
  State<ListPrice> createState() => _ListPriceState();
}

class _ListPriceState extends State<ListPrice> {
  // final user = FirebaseAuth.instance.currentUser!;
  // Call formattedDate function from FormatDatetime class
  final FormatDatetime convertDatetime = FormatDatetime();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ราคากระเทียมจีน',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        child: StreamBuilder<List<ListPriceModel>>(
          stream: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong!!! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final user = snapshot.data!;

              return ListView(
                children: user.map(buildUser).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildUser(ListPriceModel price) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListTile(
          // call DateTime format Function
          leading: Text(
            convertDatetime
                .formattedDate(price.dateTime.millisecondsSinceEpoch),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          title: CircleAvatar(child: Text('${price.price}')),

          // subtitle: Text(user.city),
        ),
      );

  Stream<List<ListPriceModel>> readUser() => FirebaseFirestore.instance
      .collection('price')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ListPriceModel.fromJson(doc.data()))
          .toList());
}
