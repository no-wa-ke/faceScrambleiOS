#include "ofApp.h"

bool imageLoaded = false;
bool libOpen = false;
bool imageReady;
bool srcReady;

int saveCount = 0;

ofFile file;

ofBuffer photoBuffer;

vector<ofVec2f> srcPoints;

ofImage newImage;

ofMesh objectMesh;

ofMesh imgMesh;


//ofVec2f texCoord;
//ofVec2f &cood = texCoord;

//--------------------------------------------------------------
void ofApp::setup(){
    
 
    
    ofSetFrameRate(24);
    ofSetVerticalSync(true);

    #ifdef CAM_MODE
    cam.setDeviceID(1);
    cam.initGrabber(ofGetWidth(), ofGetHeight());
    #endif
    
    newImage.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR_ALPHA);
    faceImage.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR_ALPHA);
    //fbo.allocate(ofGetWidth(), ofGetHeight(), GL_RGBA);
    
    
    #ifdef DEBUG_MODE
    cam.loadImage("faces/1.jpg");
    cam.allocate(ofGetWidth(), ofGetHeight(), OF_IMAGE_COLOR_ALPHA);
    #endif

    faceImage.loadImage("faces/2.jpg");

  
    tracker.setup();
    imgTracker.setAttempts(2);
    imgTracker.setIterations(5);
    
    imgTracker.setup();
    imgTracker.setAttempts(4);
    imgTracker.setIterations(25);
    
    
    
    
    
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    cam.update();
    
    updateImage();
    
#ifdef CAM_MODE
    if(cam.isFrameNew()&& faceImage.getWidth()>0 &&!libOpen) {
#endif
    
#ifdef DEBUG_MODE
    if(faceImage.getWidth()>0 && !libOpen) {
#endif
        
        imgTracker.update(ofxCv::toCv(faceImage));
        tracker.update(ofxCv::toCv(cam));
        imageReady = tracker.getFound();
        srcReady = imgTracker.getFound();
        
        if(imageReady && srcReady){ // wait for video AND image to be found.
            
            objectMesh = tracker.getObjectMesh();

            for(int i=0; i< objectMesh.getTexCoords().size(); i++) {
                ofVec2f &texCoord = objectMesh.getTexCoords()[i];
                texCoord.x /= ofNextPow2(ofGetWidth());
                texCoord.y /= ofNextPow2(ofGetHeight());
                
                
            }
            
            imgMesh = imgTracker.getImageMesh();

                for(int i=0; i< imgMesh.getTexCoords().size(); i++) {
                ofVec2f &texCoord = imgMesh.getTexCoords()[i];
                texCoord.x /= ofNextPow2(faceImage.getWidth());
                texCoord.y /= ofNextPow2(faceImage.getHeight());
                
            }
            
            for(int i = 0; i < objectMesh.getNumVertices();i++){
                ofVec3f vertex = objectMesh.getVertex(i);
                imgMesh.setVertex(i, vertex);
             
            }
        }
    }
    

     


}

//--------------------------------------------------------------
void ofApp::draw(){
    
 
    
    if(!libOpen){
    
    ofPushMatrix();
    ofTranslate(ofGetWidth(), 0);
    ofScale(-1,1,1);
    ofSetColor(255);
    cam.draw(0,0);
    

    
    if(tracker.getFound()) {
        
        ofVec2f position = tracker.getPosition();
        ofVec3f orientation = tracker.getOrientation();
        float scale = tracker.getScale();
        
        ofPushMatrix();
        ofTranslate(position.x, position.y,1);
        ofScale(scale/1.2, scale, scale);
        
        ofRotateX(orientation.x*45.0f);
        ofRotateY(orientation.y*45.0f);
        ofRotateZ(orientation.z*45.0f);
        ofSetColor(255,255,220,225);
        
        
        if (imgTracker.getFound()){
        faceImage.getTextureReference().bind();
        imgMesh.draw();
        faceImage.getTextureReference().unbind();
       
        }

        
        ofPopMatrix();
        
    }
        ofPopMatrix();
  

        ofDrawBitmapString(ofToString((int) ofGetFrameRate()), 10,ofGetHeight()-10 );
        ofSetColor(255,255,255,255);
        
        if(faceImage.getWidth() <= 300){
        faceImage.draw(0, 0, faceImage.getWidth()/3, faceImage.getHeight()/3);
        } else if (faceImage.getWidth() >= 300){
        faceImage.draw(0, 0, faceImage.getWidth()/5, faceImage.getHeight()/5);
            
        }
        //        newImage.draw(0,ofGetHeight()-newImage.getHeight()/3,newImage.getWidth()/3,newImage.getHeight()/3);
        //imgTracker.draw();
        
    }

  


    
}



//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
    

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
    if(touch.id == 0){
        
        libOpen = true;
        
        imgMesh.clearTexCoords();
        objectMesh.clearTexCoords();
        tracker.reset();
        imgTracker.reset();
        faceImage.clear();
        photoBuffer.clear();
        
        camera.openLibrary();

        
    }
    
    
}


//-------------------------------------------------------------------------
void ofApp::updateImage(){

    if(camera.imageUpdated){
        
        //set up new context
        int cameraW = camera.width;
        int cameraH = camera.height;
        unsigned const char * cameraPixels = camera.pixels;
        
        //over 1000 gives some errors
        camera.setMaxDimension(600);
        
        //trying to allocate new Picture
        newImage.setFromPixels(cameraPixels,cameraW ,cameraH, OF_IMAGE_COLOR_ALPHA);
        
        //pass to new file
        ofSaveImage(newImage.getPixelsRef(), photoBuffer);
        file.open(ofxiOSGetDocumentsDirectory()+"newFace.jpg",ofFile::ReadWrite);
        file << photoBuffer;
        cout << file << endl;
        file.close();
        

        //load the new file
        faceImage.loadImage(ofxiOSGetDocumentsDirectory()+"newFace.jpg");
      
        
        if (faceImage.getWidth() > 0) {
            
            
            imgTracker.update(ofxCv::toCv(faceImage));
            srcPoints = imgTracker.getImagePoints();
            
            if(imgTracker.getFound()){
                cout << "cvReset" << endl;
                
            }
   
        }
        cout <<"newWidth : " << camera.width << ", newHeight: " << camera.height << endl;
        cout <<"newWidth : " << newImage.getWidth() << ", newHeight :" << newImage.getHeight() << endl;
        cout <<"faceWidth : " << faceImage.getWidth() << ", faceHeight :" << faceImage.getHeight() << endl;
        
        imgMesh.addTexCoords(srcPoints);
        camera.close();
        camera.imageUpdated = false;
        libOpen = false;
        
    }




}

//--------------------------------------------------------------
void ofApp::reloadFace(){
        
    }
    
//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

void ofApp::getImageSize(){
}
void ofApp::getDefaultSize(){
}
//--------------------------------------------------------------
void ofApp::exit(){
        
        photoBuffer.clear();
        imgMesh.clear();
        objectMesh.clear();
        tracker.reset();
        imgTracker.reset();
        faceImage.clear();

        
    }

