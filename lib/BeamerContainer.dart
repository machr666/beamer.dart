#library('doc:ic:ac:uk:beamer:container');

// Std libs
#import('dart:html');

// 3rd party libs
#import("../3rd-party/log4dart/Lib.dart");

// Beamer source files
#import("Common.dart");
#import("MSGs.dart");

class BeamerContainer {
  /** Singleton instance */
  static BeamerContainer _inst;
  
  /** iFrame container element */
  Element mContainer;
    
  /** Ratio of slides */
  num mSlideRatio;
 
  /**
  * Create a singleton
  */
  factory BeamerContainer() {
    if (_inst == null)
    {
      _inst = new BeamerContainer._internal();
    }
    return _inst;
  }
  
  /**
  * Private constructor
  */
  BeamerContainer._internal() {   
    // Load iFrame
    mContainer = document.query("#container");    
    
    // Config frame
    String slideRatio = mContainer.attributes["slide-ratio"];
    if (slideRatio == null ||
        slideRatio == "fullscreen") {
      mSlideRatio = 0.0;
    }
    else {
      List l = slideRatio.split(":");
      mSlideRatio = Math.parseDouble(l[0])/Math.parseDouble(l[1]);
    }   
    Common.getLogger().debug(MSGs.BEAMERCONTAINER_SLIDE_RATIO + mSlideRatio);
    Common.getLogger().debug(MSGs.BEAMERCONTAINER_CREATED);
  }

  /**
  * Create centered frame so that the container is the largest
  * possible frame according to the chosen slide ratio.
  */
  setupPresentationContainer() {
    // Reset
    mContainer.style.top="0px";    
    mContainer.style.left="0px";
    mContainer.style.marginTop="0px";
    mContainer.style.marginBottom="0px";
    mContainer.style.marginLeft="0px";
    mContainer.style.marginRight="0px";
    
    // Setup screen
    int hScreen = document.window.innerHeight;
    int wScreen = document.window.innerWidth;
    
    // Default is fullscreen    
    if (mSlideRatio == 0.0) {
      Common.getLogger().debug(MSGs.BEAMERCONTAINER_FULLSCREEN);
      return;
    }

    // Use part of window
    num ratioScreen = wScreen/hScreen;
    if (ratioScreen < mSlideRatio) {
      // Use full width, just adjust top and bottom padding
      num padding = (hScreen-wScreen/mSlideRatio)/2;
      mContainer.style.marginTop="${padding}px";
      mContainer.style.marginBottom="${padding}px";
      mContainer.style.width="100%";
      mContainer.style.height="${(hScreen-2*padding)/hScreen*100}%";
      Common.getLogger().debug(MSGs.BEAMERCONTAINER_PAD_TOP_AND_BOTTOM+"${padding}px");
    }
    else {
      // Use full height, just adjust left and right padding
      num padding = (wScreen-hScreen*mSlideRatio)/2;
      mContainer.style.marginLeft="${padding}px";
      mContainer.style.marginRight="${padding}px";
      mContainer.style.height="100%";
      mContainer.style.width="${(wScreen-2*padding)/wScreen*100}%";
      Common.getLogger().debug(MSGs.BEAMERCONTAINER_PAD_LEFT_AND_RIGHT+"${padding}px");
    } 
  }
}

void main() {
  BeamerContainer container = new BeamerContainer();
  container.setupPresentationContainer();
  
  // Rescale container when window is resized
  window.on.resize.add((event) {
    container.setupPresentationContainer();
  });
    
  // Set focus to the presentation iFrame container
  container.mContainer.focus();
  window.on.resize.add((event) {
    container.mContainer.focus();
  });
  window.on.click.add((event) {
    container.mContainer.focus();
  });  
}
