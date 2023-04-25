import 'package:intl/intl.dart';

extension ExtDateTime on DateTime {

  String toDateInfoFormat() {
    String result = DateFormat("dd/MM/yyyy").format(this);
    return result;
  }

  String toDateMiniTripFormat() {
    String result = DateFormat("MMM/dd/yyyy").format(this);
    return result;
  }

}

