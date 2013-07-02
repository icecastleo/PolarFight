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

#import "CCShake.h"

@implementation CCShake

+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude {
    return [self actionWithDuration:t amplitude:amplitude dampening:YES shakes:CCSHAKE_EVERY_FRAME];
}

+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude dampening:(BOOL)dampening {
    return [self actionWithDuration:t amplitude:amplitude dampening:dampening shakes:CCSHAKE_EVERY_FRAME];
}

+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude shakes:(int)shakeNum {
    return [self actionWithDuration:t amplitude:amplitude dampening:true shakes:shakeNum];
}

+(id)actionWithDuration:(ccTime)t amplitude:(CGPoint)amplitude dampening:(BOOL)pdampening shakes:(int)shakeNum {
    return [[[self alloc] initWithDuration:t amplitude:amplitude dampening:pdampening shakes:shakeNum] autorelease];
}

-(id)initWithDuration:(ccTime)t amplitude:(CGPoint)pAmplitude dampening:(BOOL)bDampening shakes:(int)shakeNum {
    if((self = [super initWithDuration:t]) != nil) {
        startAmplitude = pAmplitude;
        dampening = bDampening;
        
        // calculate shake intervals based on the number of shakes
        if (shakeNum == CCSHAKE_EVERY_FRAME) {
            shakeInterval = 0;
        } else {
            shakeInterval = 1.f/shakeNum;
        }
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] amplitude:amplitude dampening:dampening shakes:shakeInterval == 0 ? 0 : 1/shakeInterval];
    
    return copy;
}

-(void)startWithTarget:(CCNode *)aTarget {
    [super startWithTarget:aTarget];
    
    initPosition = ((CCNode*)_target).position;
    
    amplitude = startAmplitude;
    nextShake = 0;    
}

-(void)stop {
    [_target setPosition:initPosition];
    [super stop];
}

-(void)update:(ccTime)t {
    if(shakeInterval != CCSHAKE_EVERY_FRAME) {
        if(t < nextShake) {
            // haven't reached the next shake time yet
            return;
        } else {
            // proceed with shake this time and increment for next shake goal
            nextShake += shakeInterval;
        }
    }
    
    // calculate the dampening effect, if being used
    if (dampening) {
        float dFactor = (1-t);
        
        amplitude.x = dFactor * startAmplitude.x;
        amplitude.y = dFactor * startAmplitude.y;
    }
    
    CGPoint new = ccp((CCRANDOM_0_1()*amplitude.x*2) - amplitude.x, (CCRANDOM_0_1()*amplitude.y*2) - amplitude.y);

    // simultaneously un-move the last shake and move the next shake    
    [_target setPosition:ccpAdd(initPosition, new)];
}

@end