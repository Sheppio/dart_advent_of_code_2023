class ConsoleColors {
  //https://stackoverflow.com/questions/43528123/visual-studio-code-debug-console-colors
  //https://gist.github.com/mgumiero9/665ab5f0e5e7e46cb049c1544a00e29f
  static String black = '\u001b[1;30m';
  static String red = '\u001b[1;31m';
  static String green = '\u001b[1;32m';
  static String yellow = '\u001b[1;33m';
  static String blue = '\u001b[1;34m';
  static String purple = '\u001b[1;35m';
  static String cyan = '\u001b[1;36m';
  static String white = '\u001b[1;37m';

  static String redBg = '\u001b[1;41m$black';
  static String greenBg = '\u001b[1;42m$black';
  static String yellowBg = '\u001b[1;43m$black';
  static String blueBg = '\u001b[1;44m$black';
  static String purpleBg = '\u001b[1;45m$black';
  static String cyanBg = '\u001b[1;46m$black';

  static String reset = '\u001b[0m';
}
