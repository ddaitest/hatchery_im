class Log {
  static final String _ANSI_RESET = "\u001B[0m";
  static final String _ANSI_BLACK = "\u001B[30m";
  static final String _ANSI_RED = "\u001B[31m";
  static final String _ANSI_GREEN = "\u001B[32m";
  static final String _ANSI_YELLOW = "\u001B[33m";
  static final String _ANSI_BLUE = "\u001B[34m";
  static final String _ANSI_PURPLE = "\u001B[35m";
  static final String _ANSI_CYAN = "\u001B[36m";
  static final String _ANSI_WHITE = "\u001B[37m";
  static final String _ANSI_Magenta = "\033[35;1m";

  static log(String msg, {LColor color = LColor.WHITE}) {
    switch (color) {
      case LColor.WHITE:
        print("$_ANSI_WHITE $msg $_ANSI_RESET");
        break;
      case LColor.RED:
        print("$_ANSI_RED $msg $_ANSI_RESET");
        break;
      case LColor.BLUE:
        print("$_ANSI_BLUE $msg $_ANSI_RESET");
        break;
      case LColor.GREEN:
        print("$_ANSI_GREEN $msg $_ANSI_RESET");
        break;
      case LColor.YELLOW:
        print("$_ANSI_YELLOW $msg $_ANSI_RESET");
        break;
      case LColor.Magenta:
        print("$_ANSI_Magenta $msg $_ANSI_RESET");
        break;
    }
  }
}

enum LColor { WHITE, RED, BLUE, GREEN, YELLOW, Magenta }
