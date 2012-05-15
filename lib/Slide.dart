#library('doc:ic:ac:uk:beamer:main');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("MSGsEn.dart");

/**
* This class describes the configuration of a slide.
*/
class SlideConfig
{
  bool mShowPageNum;
  
  SlideConfig(Element e, [SlideConfig defaultCfg=null]) {
    
    // Use default config
    copyFrom(defaultCfg);
  
    // Override custom config
    if (e.attributes["show-page-num"] != null) {
      mShowPageNum = (e.attributes["show-page-num"] == "true");
    }
  }

  /**
  * Copy configuration from another object
  */
  copyFrom(SlideConfig cfg)
  {
    if (cfg != null) {
      mShowPageNum = cfg.mShowPageNum;
    }
  }
}

/**
* This class creates, contains and manages all slides.
*/
class SlideContainer
{
  // Logger
  static Logger _logger;
  
  // Singleton
  static SlideContainer _inst;
  
  // SlideContainer
  final SlideConfig _defCfg;
  List<Slide> mSlides;
  
  /**
  * Create a singleton
  */
  factory SlideContainer(SlideConfig cfg) {
    if (_inst == null)
    {
      _logger = LoggerFactory.getLogger("SlideFactoryLogger");
      _logger.debug(MSGs.SLIDECONTAINER_CREATED);
      _inst = new SlideContainer._internal(cfg);
    }
    return _inst;
  }
  
  /**
  * Private constructor
  */
  SlideContainer._internal(this._defCfg);
  
  /**
  * Create slides from HTML description
  */
  void genSlides(ElementList slidesElts) {
    List<Slide> mSlides = new List<Slide>();
    slidesElts.forEach((Element e) {
      mSlides.add(new Slide(e,_defCfg));
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
}

/**
* This class describes a single slide.
*/
class Slide
{
  Element mElt;
  SlideConfig mCfg;
  
  Slide(Element elt, SlideConfig defaultCfg)
  {
    mElt = elt;
    mCfg = new SlideConfig(elt,defaultCfg);
  }
  
  void render()
  {
  }
}
