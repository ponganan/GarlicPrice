import 'package:intl/intl.dart';

class FormatDatetime {
  String formattedDate(timeStamp) {
    var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    //return DateFormat('dd-MM-yyyy hh:mm a').format(dateFromTimeStamp);
    return DateFormat('dd-MM-yyyy').format(dateFromTimeStamp);
  }
}
