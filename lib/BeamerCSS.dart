#library('doc:ic:ac:uk:beamer:css');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Common.dart");
#import("MSGs.dart");

/**
* Create CSS3 styles with maximum
* browser compatibility.
*/
class BeamerCSS {
  
  /** Browsers */
  static List<String> getBrowsers() {
    return ["","-webkit","-moz","-o","-ms"];
  }

  static String basicLayout() {
    return "position: absolute; top: 0px; left: 0px;";
  }

  /** Browser independent CSS3 transition */
  static String transition(String trans) {
    String css = "";
    if (trans == "") return css;
    getBrowsers().forEach((String s) => css += "${s}-transition: ${trans};");
    return css;
  }
  
  /** Browser independent CSS3 transform-origin */
  static String transformOrigin(num xRel, num yRel) {
    String css = "";
    getBrowsers().forEach((String s) => css += "${s}-transform-origin: ${xRel}% ${yRel}%;");
    return css;
  }
  
  /** Browser independent CSS3 transform-style */
  static String transformStyle() {
    String css = "";
    getBrowsers().forEach((String s) => css += "${s}-transform-style: preserve-3d;");
    return css;
  }
  
  /** Browser independent CSS3 translation */
  static String translate(num x, num y, num z) {
    String css = "";
    getBrowsers().forEach((String s) => css += "${s}-transform: translate3d(${x}px, ${y}px, ${z}px);");
    return css;
  }
}
