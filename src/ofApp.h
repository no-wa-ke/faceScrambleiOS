#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxOpenCv.h"
//#include "ofxCv.h"
#include "ofxFaceTracker.h"
#include "Clone.h"

#define CAM_MODE              //<<----------------- turn camera ON
//#define DEBUG_MODE              //<<----------------- test picture for debug


class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
        void loadFace();
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
        void getImageSize();
        void getDefaultSize();
    
        void reloadFace();
        void updateImage ();
    

   
    #ifdef CAM_MODE
    ofVideoGrabber cam;
    #endif
    
    #ifdef DEBUG_MODE
    ofImage cam;
    #endif
    Clone clone;
    ofxFaceTracker tracker;
    ofxFaceTracker imgTracker;
    ofImage faceImage;
    
    ofDirectory faces;
    
    
    
    ofFbo fbo;

    ofxiOSImagePicker  camera;
    
    
//    ofxEasyRetina retina; //declare an ofxEasyRetina instance
};


