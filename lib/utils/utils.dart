import 'package:intl/intl.dart';

extension ExtDateTime on DateTime {
  String toHighlightFormat() {
    String result = DateFormat("MMMM dd, yyyy").format(this);
    return result;
  }

  String toNewsFormat() {
    String result = DateFormat("MMM dd, yyyy").format(this);
    return result;
  }

  String toMatchFormat() {
    String result = DateFormat("EEE dd/M")
        .format(add(Duration(hours: DateTime.now().timeZoneOffset.inHours)));
    return result;
  }

  String toMatchDetailFormat() {
    String result = DateFormat("dd/MM/yy").format(this);
    return result;
  }

  String toHourMatchFormat() {
    String result = DateFormat()
        .add_jm()
        .format(add(Duration(hours: DateTime.now().timeZoneOffset.inHours)));
    return result;
  }
}

extension ExtTime on int {
  String toTimeFormat() {
    String twoDigits(int x) {
      if (x < 10) return "0$x";
      return "$x";
    }

    int hour = this ~/ 3600;
    int min = (this % 3600) ~/ 60;
    int sec = this % 60;
    if (hour > 0) {
      return "$hour:${twoDigits(min)}:${twoDigits(sec)}";
    } else {
      return "${twoDigits(min)}:${twoDigits(sec)}";
    }
  }
}

extension ExtDuration on Duration {
  String toTimeFormat() {
    String twoDigits(int x) {
      if (x < 10) return "0$x";
      return "$x";
    }

    int hour = inSeconds ~/ 3600;
    int min = (inSeconds % 3600) ~/ 60;
    int sec = inSeconds % 60;
    if (hour > 0) {
      return "$hour:${twoDigits(min)}:${twoDigits(sec)}";
    } else {
      return "${twoDigits(min)}:${twoDigits(sec)}";
    }
  }
}
