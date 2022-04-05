class ValidatorService {
  static String supportedCharacters = '_, @, .';

  static bool validateEmail(String text) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text);
  }

  static bool alphaNumeric(String text) {
    return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(text);
  }

  static bool numeric(String text) {
    return RegExp(r"^[0-9]+$").hasMatch(text);
  }

  static bool alphabetic(String text) {
    return RegExp(r"^[a-zA-Z]+$").hasMatch(text);
  }

  static bool bothAlphabeticAndNumeric(String text) {
    return alphabetic(text) && numeric(text);
  }

  static bool alphaNumericAndSpecialCharacter(String text) {
    return RegExp(r'^[a-zA-Z0-9_@\.]+$').hasMatch(text);
  }

  static bool length(String text, {int? min, int? max}) {
    bool valid = true;

    if (min != null) {
      valid = text.length >= min;
      if (!valid) return valid;
    }

    if (max != null) {
      valid = text.length <= max;
      if (!valid) return valid;
    }

    return valid;
  }

  static bool notEmpty(String text) {
    return text.isNotEmpty;
  }

  static bool notNull(String text) {
    return text != null;
  }
}
