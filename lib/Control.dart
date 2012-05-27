#library('doc:ic:ac:uk:beamer:control');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Common.dart");
#import("MSGs.dart");
#import("Slide.dart");

/**
* This class provides methods
* for controlling the presentation
* flow.
*/
class Control {
  
  /** Slides */
  SlideContainer mSlides;
    
  /**
  * Public Constructor
  */
  Control(this.mSlides) {
    // Register events
    window.on.resize.add((Event evt) => render());
    document.on.keyUp.add((UIEvent evt) => keyHandler(evt));
    
    Common.getLogger().debug(MSGs.CONTROL_CREATED);
  }
   
  /**
  * Create HTML
  */
  void render() {
    mSlides.render();
  }
  
  /**
  * Key event handler
  */
  void keyHandler(UIEvent evt) {
    switch (evt.keyCode) {
      case 37: // left
        mSlides.prevStep();
        break;
      case 39: // right
        mSlides.nextStep();
        break;
      case 38: // up
        break;
      case 40: // down
        break;
      case 9:  // tab
        break;
      case 32: // space
        break;
    }
    evt.preventDefault();
  }
}
