#include "ofMain.h"
#include "ofApp.h"



int main(){
    
    
    
//	ofSetupOpenGL(1024,768,OF_FULLSCREEN);			// <-------- setup the GL context
//	ofRunApp(new ofApp());

    ofAppiOSWindow * window = new ofAppiOSWindow();
    window->enableRendererES2();
    window->enableDepthBuffer();
//    window->enableRetina();
    
    ofSetupOpenGL(window,1024,768, OF_FULLSCREEN);         // <-------- setup the GL context
    ofRunApp(new ofApp);


}
