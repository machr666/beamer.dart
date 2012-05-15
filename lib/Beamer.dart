#library('doc:ic:ac:uk:beamer:slide');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Slide.dart");
#import("MSGsEn.dart");

class Beamer {
  // Logger
  static Logger _logger;
  
  // Singleton
  static Beamer _inst;
  
  // The top level elements
  Element mBeamer;
  Element mCanvas;
  Element mTopPadding;
  Element mBottomPadding;
  Element mRightPadding;
  Element mLeftPadding;
    
  // Config
  double mSlideRatio;
  
  // Slides
  SlideContainer mSlides;
  
  /**
  * Create a singleton
  */
  factory Beamer() {
    if (_inst == null)
    {
      _logger = LoggerFactory.getLogger("BeamerLogger");
      _logger.debug(MSGs.BEAMER_CREATED);
      _inst = new Beamer._internal();
    }
    return _inst;
  }
  
  Beamer._internal()
  {
    _logger = LoggerFactory.getLogger("SlideFactoryLogger");
    // Load elements
    mBeamer = document.query("#beamer");
    mBeamer.innerHTML = '<div id="canvas">'+ mBeamer.innerHTML +'</div>';
    mCanvas = document.query("#canvas");
    mTopPadding = document.query("#topPadding");
    mBottomPadding = document.query("#bottomPadding");
    mLeftPadding = document.query("#leftPadding");
    mRightPadding = document.query("#rightPadding");
    
    // Config
    String slideRatio = mBeamer.attributes["slide-ratio"];
    if (slideRatio == null ||
        slideRatio == "fullscreen") {
      mSlideRatio = 0.0;
    }
    else {
      List l = slideRatio.split(":");
      mSlideRatio = Math.parseDouble(l[0])/Math.parseDouble(l[1]);
    }
    _logger.debug(MSGs.BEAMER_SLIDE_RATIO + mSlideRatio);
  }

  /**
  * Adjust everything to match the current window size
  */
  setupScreen() {
    // Setup screen
    int hScreen = document.window.innerHeight;
    int wScreen = document.window.innerWidth;
    
    // Default is fullscreen    
    if (mSlideRatio == 0.0) {
      _logger.debug(MSGs.BEAMER_PAD_NONE);
      return;
    }
        
    // Need to pad to achieve correct slide ratio
    double ratioScreen = wScreen/hScreen;
    if (ratioScreen < mSlideRatio) {
      // Use full width, just adjust top and bottom padding
    //  mTopPadding.style.width = "${wScreen}px";
   //   mBottomPadding.style.width = "${wScreen}px";
      double padding = ((wScreen/mSlideRatio)-hScreen)/2;
     // mTopPadding.style.height = "${padding}px";
     // mBottomPadding.style.height = "${padding}px";
      mBeamer.style.marginTop="${padding}px";
      mBeamer.style.marginBottom="${padding}px";
      mBeamer.style.width="${wScreen}px";
      
      _logger.debug(MSGs.BEAMER_PAD_TOP_AND_BOTTOM+"${padding}px");
    }
    else {
      // Use full height, just adjust left and right padding
   //   mLeftPadding.style.height = "${hScreen}px";
   //   mRightPadding.style.height = "${hScreen}px";
      double padding = (wScreen-(mSlideRatio*hScreen))/2;
   //   mLeftPadding.style.width = "${padding}px";
   //   mRightPadding.style.width = "${padding}px";
      mBeamer.style.marginLeft="${padding}px";
      mBeamer.style.marginRight="${padding}px";
      mBeamer.style.height="${hScreen}px";
      _logger.debug(MSGs.BEAMER_PAD_LEFT_AND_RIGHT+"${padding}px");
    }
  }
  
  void setupPresentation() {   
    // Beamer.dart is supported
    document.body.classes.remove("beamer-not-supported");
    document.body.classes.add("beamer-supported");
    mCanvas.query("#no-dart-support-msg").remove();
   
    // Create all slides
    mSlides = new SlideContainer(new SlideConfig(mBeamer));
    mSlides.genSlides(mCanvas.queryAll(".slide"));
    
    // Render
    render();
  }
  
  /**
  * Create HTML
  */
  void render() {
    setupScreen();
    mSlides.render();
  }
}

void main() {
  Beamer presentation = new Beamer();
  presentation.setupPresentation();
}
