import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart' as ai;


class TimeUtil {
  String  ago(String time){
   return Jiffy.parse(time).fromNow();
  }


 static String formatMMMMDY(String dateString){
    DateTime dateTime = DateTime.parse(dateString);
   return ai.DateFormat('MMMM d, y \'at\' h:mm a').format(dateTime);
  }
}