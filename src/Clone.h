//
//  Clone.h
//  faceScrambleiOS
//
//  Created by Kido Yoji on 2014/08/25.
//
//

#ifndef __faceScrambleiOS__Clone__
#define __faceScrambleiOS__Clone__

#include <iostream>

#endif /* defined(__faceScrambleiOS__Clone__) */

#include "ofMain.h"
//#include "ofxiOS.h"
//#include "ofxiOSExtras.h"



class Clone {
public:
	void setup(int width, int height);
	void setStrength(int strength);
	void update(ofTexture& src, ofTexture& dst, ofTexture& mask);
	void draw(float x, float y);
	
protected:
	void maskedBlur(ofTexture& tex, ofTexture& mask, ofFbo& result);
	ofFbo buffer, srcBlur, dstBlur;
	ofShader maskBlurShader, cloneShader;
	int strength;
};