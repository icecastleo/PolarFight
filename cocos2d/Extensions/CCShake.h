/*
 * CCShake
 *
 * Copyright (c) 2011 Paul Langworthy
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "cocos2d.h"

#define CCSHAKE_EVERY_FRAME	0

@interface CCShake : CCActionInterval {
    float shakeInterval;
    float nextShake;
    bool dampening;
    
    CGPoint initPosition;
    
    CGPoint startAmplitude;
    CGPoint amplitude;
}

// amplitude (required): The maximum number of pixels +/- that the object will randomly move around within. I made it a CGPoint in case you want to skew the shake in one direction or the other, as I did.

// dampening (optional): If true, the amplitude will shrink to 0 over the course of the action, which makes the action appear more “jarring.” if false, the object will continue to move around within the full amplitude range for the entire duration of the action. Default value is true.

// shakes (optional): If not set or set to 0, the object will change position every frame. Otherwise it will only move the specified number of times over the course of the action. Default value is 0 (shake every frame), although this is not generally recommended if you’re running at 60FPS.

+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude;
+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude dampening:(BOOL)dampening;
+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude shakes:(int)shakeNum;
+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude dampening:(BOOL)dampening shakes:(int)shakeNum;
-(id)initWithDuration:(ccTime)t amplitude:(CGPoint)pAmplitude dampening:(BOOL)bDampening shakes:(int)shakeNum;

@end
