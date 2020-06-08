enum Rotation {
  daily,
  weekly,
  monthly,
  twoWeekly,
  threeWeekly,
  allTwoDays,
  allThreeDays,
  allFourDays,
  allFiveDays,
  allSixDays,
}

extension DurationExtension on Rotation {
  static const day = 86400;

  String get name {
    switch (this) {
      case Rotation.daily:
        return "Täglich";
        break;
      case Rotation.weekly:
        return "Wöchentlich";
        break;
      case Rotation.monthly:
        return "Monatlich";
        break;
      case Rotation.twoWeekly:
        return "Zweiwöchentlich";
        break;
      case Rotation.threeWeekly:
        return "Dreiwöchentlich";
        break;
      case Rotation.allTwoDays:
        return "Alle zwei Tage";
        break;
      case Rotation.allThreeDays:
        return "Alle drei Tage";
        break;
      case Rotation.allFourDays:
        return "Alle vier Tage";
        break;
      case Rotation.allFiveDays:
        return "Alle fünf Tage";
        break;
      case Rotation.allSixDays:
        return "Alle sechs Tage";
        break;
    }
    return "";
  }

  int get duration {
    switch (this) {
      case Rotation.daily:
        return day;
        break;
      case Rotation.weekly:
        return day * 7;
        break;
      case Rotation.monthly:
        return day * 30;
        break;
      case Rotation.twoWeekly:
        return day * 14;
        break;
      case Rotation.threeWeekly:
        return day * 21;
        break;
      case Rotation.allTwoDays:
        return day * 2;
        break;
      case Rotation.allThreeDays:
        return day * 3;
        break;
      case Rotation.allFourDays:
        return day * 4;
        break;
      case Rotation.allFiveDays:
        return day * 5;
        break;
      case Rotation.allSixDays:
        return day * 6;
        break;
    }
    return 0;
  }
}
