#library('doc:ic:ac:uk:beamer:common');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

class Common {
  
  static Logger getLogger() => LoggerFactory.getLogger("BeamerLogger");
  
  /** Boolean */
  static final String TRUE = "true";
  static final String FALSE = "false";

  /** Beamer.dart IDs*/
  static final String ID_CONTAINER = "container";
  static final String ID_BEAMER = "beamer";
  static final String ID_CANVAS = "canvas";
  static final String ID_NO_SUPPORT = "no-dart-support-msg";
  
  /** Beamer.dart classes*/
  static final String CLS_NOT_SUPPORTED = "BeamerNotSupported";
  static final String CLS_SUPPORTED = "BeamerSupported";
  static final String CLS_BEAMER = "Beamer";
  static final String CLS_CANVAS = "Canvas";
  static final String CLS_SLIDE = "Slide";
  static final String CLS_SLIDE_HEADER = "SlideHeader";
  static final String CLS_SLIDE_TITLE = "SlideTitle";
  
  /** Slide Options*/
  static final String SO_SHOW_SLIDE_NUM = "show-slide-num";
  static final String SO_OFFSET_X = "offset-x";
  static final String SO_OFFSET_Y = "offset-y";
  static final String SO_OFFSET_Z = "offset-z";
  static final String SO_OUT_ANI = "out-animation";
  static final String SO_TITLE = "title";
}
