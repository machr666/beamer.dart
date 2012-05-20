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
      offset-x == 1 means the next slide begins where the
      last one ends. offset-y == 1 means the next slide is
      above the previous. offset-z == 0 means the next slide
      lies on the same z-plane as the previous slide.*/
  double mOffsetX;
  double mOffsetY;
  double mOffsetZ;
  
  /**
  * Public Constructor
  */
  SlideConfig(Element e, [SlideConfig defaultCfg=null]) {
    // Use default config
    copyFrom(defaultCfg);
  
    // Override custom config
    if (e.attributes[Common.SHOW_SLIDE_NUM] != null) {
      mShowSlideNum = (e.attributes[Common.SHOW_SLIDE_NUM] == Common.TRUE);
    }
    
    if (e.attributes[Common.OFFSET_X] != null) {
      mOffsetX = Math.parseDouble(e.attributes[Common.OFFSET_X]);
    }

    if (e.attributes[Common.OFFSET_Y] != null) {
      mOffsetY = Math.parseDouble(e.attributes[Common.OFFSET_Y]);
    }

    if (e.attributes[Common.OFFSET_Z] != null) {
      mOffsetZ = Math.parseDouble(e.attributes[Common.OFFSET_Z]);
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
    _defCfg.mOffsetX = 1;
    _defCfg.mOffsetY = 0;
    _defCfg.mOffsetZ = 0;
    
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
        cfg.mOffsetX = 0;
        cfg.mOffsetY = 0;
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
  * Show previous slide
  */
  void prev() {
    mActiveSlide = (mActiveSlide-1 + mSlides.length) % mSlides.length;
    Slide as = mSlides[mActiveSlide];
    moveTo(as);
  }
  
  /**
  * Show next slide
  */
  void next() {
    mActiveSlide = (mActiveSlide+1) % mSlides.length;
    Slide as = mSlides[mActiveSlide];
    moveTo(as);
  }
  
  void moveTo(Slide as)
  {
    mCanvas.style.cssText = BeamerCSS.basicLayout()
                          + BeamerCSS.transformStyle()
                          + BeamerCSS.transformOrigin(0, 0)
                          + BeamerCSS.translate(-as.getX(), -as.getY(), -as.getZ());
    Common.getLogger().debug(mCanvas.style.cssText);
  }
  
  /**
  * Show previous step in active slide
  */
  void prevStep() {
    
  }
  
  /**
  * Show next step in active slide
  */
  void nextStep() {
    
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
  
  /**
  * Generate HTML for slide
  */
  void render() {
    double h = document.window.innerHeight;
    double w = document.window.innerWidth;
    
    mElt.style.cssText = BeamerCSS.basicLayout() + "height: ${h}px; width: ${w}px;"
                       + BeamerCSS.transformOrigin(0,0)
                       + BeamerCSS.transformStyle()
                       + BeamerCSS.translate(getX(), getY(), getZ());
    Common.getLogger().debug("${MSGs.SLIDE_STYLE} #${mSlideNum} \{ ${mElt.style.cssText} \}");
  }
}
