#library('doc:ic:ac:uk:beamer:main');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Common.dart");
#import("MSGs.dart");
#import("BeamerCSS.dart");

/**
* This class describes the configuration of a slide.
*/
class SlideConfig {
  /** Iff true slide numbers are show in presentation */
  bool mShowSlideNum;
  /** Offset of slide compared to the last slide.
   *  offset-x == 1 means the next slide begins where the
   *  last one ends. offset-y == 1 means the next slide is
   *  above the previous. offset-z == 0 means the next slide
   *  lies on the same z-plane as the previous slide.
   */
  double mOffsetX;
  double mOffsetY;
  double mOffsetZ;

  /**
  * Control the animation out of the slide and into the
  * slide when stepping back from the next slide.
  */
  String mOutTrans;
  
  /**
  * Public Constructor
  */
  SlideConfig(Element e, [SlideConfig defaultCfg=null]) {
    // Use default config
    copyFrom(defaultCfg);
  
    // Override custom config
    if (e.attributes[Common.SO_SHOW_SLIDE_NUM] != null) {
      mShowSlideNum = (e.attributes[Common.SO_SHOW_SLIDE_NUM] == Common.TRUE);
    }
    
    if (e.attributes[Common.SO_OFFSET_X] != null) {
      mOffsetX = Math.parseDouble(e.attributes[Common.SO_OFFSET_X]);
    }

    if (e.attributes[Common.SO_OFFSET_Y] != null) {
      mOffsetY = Math.parseDouble(e.attributes[Common.SO_OFFSET_Y]);
    }

    if (e.attributes[Common.SO_OFFSET_Z] != null) {
      mOffsetZ = Math.parseDouble(e.attributes[Common.SO_OFFSET_Z]);
    }
    
    if (e.attributes[Common.SO_OUT_ANI] != null) {
      mOutTrans = e.attributes[Common.SO_OUT_ANI];
    }
  }

  /**
  * Copy configuration from another object
  */
  copyFrom(SlideConfig cfg)
  {
    if (cfg != null) {
      mShowSlideNum = cfg.mShowSlideNum;
      mOffsetX = cfg.mOffsetX;
      mOffsetY = cfg.mOffsetY;
      mOffsetZ = cfg.mOffsetZ;
      mOutTrans = cfg.mOutTrans;
    }
  }

  /**
  * Make position relative to position describe in cfg
  */
  addPosition(SlideConfig cfg)
  {
    mOffsetX += cfg.mOffsetX;
    mOffsetY += cfg.mOffsetY;
    mOffsetZ += cfg.mOffsetZ;
  }
}

/**
* This class creates, contains and manages all slides
* and the view on the slides.
*/
class SlideContainer {  
  /** Singleton */
  static SlideContainer _inst;

  /** HTML elements */
  Element mBeamer;
  Element mCanvas;

  /** Default configuration */
  final SlideConfig _defCfg;
  /** All slides */
  List<Slide> mSlides;

  /** Slide control */
  int mActiveSlide;

  /**
  * Create a singleton
  */
  factory SlideContainer() {
    if (_inst == null)
    {
      _inst = new SlideContainer._internal();
    }
    return _inst;
  }

  /**
  * Private constructor
  */
  SlideContainer._internal():
    _defCfg = new SlideConfig(document.query("#${Common.ID_BEAMER}"))
  {
    // Add canvas to HTML elements
    mBeamer = document.query("#${Common.ID_BEAMER}");
    mBeamer.innerHTML = '<div id="${Common.ID_CANVAS}" style="${BeamerCSS.basicLayout()}">'+ mBeamer.innerHTML +'</div>';
    mCanvas = document.query("#${Common.ID_CANVAS}");
    
    // Beamer.dart is supported
    document.body.classes.remove("${Common.CLS_NOT_SUPPORTED}");
    document.body.classes.add("${Common.CLS_SUPPORTED}");
    mCanvas.query("#${Common.ID_NO_SUPPORT}").remove();

    // Setup addition properties of default slide configuration
    _defCfg.mShowSlideNum = false;
    _defCfg.mOffsetX = 1.0;
    _defCfg.mOffsetY = 0.0;
    _defCfg.mOffsetZ = 0.0;
    _defCfg.mOutTrans = "";
    
    // Create slides
    genSlides(mCanvas.queryAll(".${Common.CLS_SLIDE}"));
    mActiveSlide = 0;
    
    Common.getLogger().debug(MSGs.SLIDECONTAINER_CREATED);
  }

  /**
  * Create slides from HTML description
  */
  void genSlides(ElementList slidesElts) {
    mSlides = new List<Slide>();
    slidesElts.forEach((Element e) {
      // Config for this slide
      SlideConfig cfg = new SlideConfig(e,_defCfg);
      if (mSlides.length == 0) {
        // Make sure first slide is visible
        cfg.mOffsetX = 0.0;
        cfg.mOffsetY = 0.0;
      }
      else {
        // Move according to position of the last slide
        cfg.addPosition(mSlides.last().mCfg);
      }
      
      mSlides.addLast(new Slide(e,cfg,mSlides.length));
    });
  }

  /**
  * Generates HTML for slides
  */
  void render()
  {
    if (mSlides == null) return;
    mSlides.forEach((Slide s) {
      s.render();
    });
  }

  /**
  * Show previous step in active slide or go
  * back to the last step in the previous slide
  */
  void prevStep() {
    Slide as = mSlides[mActiveSlide];
    if (!as.prevStep()) {
      prev();
    }
  }

  /**
  * Show next step in active slide or go to
  * the first step in the next slide
  */
  void nextStep() {
    Slide as = mSlides[mActiveSlide];
    if (!as.nextStep()) {
      next();
    }
  }

  /**
  * Show previous slide
  */
  void prev() {
    Slide from = mSlides[mActiveSlide];
    mActiveSlide = (mActiveSlide-1 + mSlides.length) % mSlides.length;
    Slide to = mSlides[mActiveSlide];
    to.prepareLastStep();
    moveTo(to,to.getTransition());
  }

  /**
  * Show next slide
  */
  void next() {
    Slide from = mSlides[mActiveSlide];
    mActiveSlide = (mActiveSlide+1) % mSlides.length;
    Slide to = mSlides[mActiveSlide];
    to.prepareFirstStep();
    moveTo(to,from.getTransition());
  }

  void moveTo(Slide to, String trans)
  {
    mCanvas.style.cssText = BeamerCSS.basicLayout()       
                          + BeamerCSS.transition(trans)
                          + BeamerCSS.transformStyle()
                          + BeamerCSS.transformOrigin(0, 0)
                          + BeamerCSS.translate(-to.getX(), -to.getY(), -to.getZ());
    Common.getLogger().debug(mCanvas.style.cssText);
  }
}

/**
* This class describes a single slide.
*/
class Slide { 
  /** Element describing the slide */
  Element mElt;

  /** Configuration of the slide */
  SlideConfig mCfg;

  /** The number of the slide */
  int mSlideNum;
  
  /**
  * Public Constructor
  */
  Slide(this.mElt, this.mCfg, this.mSlideNum) {
    Common.getLogger().debug("${MSGs.SLIDE_CREATED} #${mSlideNum}");
  }
  
  double getX() => document.window.innerWidth*mCfg.mOffsetX;
  double getY() => document.window.innerHeight*mCfg.mOffsetY;
  double getZ() => mCfg.mOffsetZ;
  String getTransition() => mCfg.mOutTrans;
  
  /**
  * Go to first step of the slide
  */
  void prepareFirstStep() {

  }

  /**
  * Go to last step of the slide
  */
  void prepareLastStep() {

  }
  
  /**
  * Go to previous step on the slide
  * and return true. Return false
  * if the first step has been reached.
  */
  bool prevStep() {
    return false;
  }
  
  /**
  * Go to next step on the slide
  * and return true. Return false
  * if the last step has been reached.
  */
  bool nextStep() {
    return false;
  }
  
  /**
  * Generate HTML for slide
  */
  void render() {
    int h = document.window.innerHeight;
    int w = document.window.innerWidth;
    
    mElt.style.cssText = BeamerCSS.basicLayout() + "height: ${h}px; width: ${w}px;"
                       + BeamerCSS.transformOrigin(0,0)
                       + BeamerCSS.transformStyle()
                       + BeamerCSS.translate(getX(), getY(), getZ());
    Common.getLogger().debug("${MSGs.SLIDE_STYLE} #${mSlideNum} \{ ${mElt.style.cssText} \}");
  }
}
