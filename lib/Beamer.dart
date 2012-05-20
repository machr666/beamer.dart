#library('doc:ic:ac:uk:beamer:slide');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Common.dart");
#import("MSGs.dart");
#import("Control.dart");
#import("Slide.dart");

class Beamer {  
  /** Singleton instance */
  static Beamer _inst;
    
  /** Slides */
  SlideContainer mSlides;
  
  /**
  * Create a singleton
  */
  factory Beamer() {
    if (_inst == null)
    {
      _inst = new Beamer._internal();
    }
    return _inst;
  }
  
  /**
  * Private constructor
  */
  Beamer._internal()
  {
    mSlides = new SlideContainer();
    Common.getLogger().debug(MSGs.BEAMER_CREATED);
  }
}

void main() {
  Beamer presentation = new Beamer();
  Control control = new Control(presentation.mSlides);
  control.render();
}
