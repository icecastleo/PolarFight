//
//  Helper.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper

//void calc(circle cir1,circle cir2)
+(CGPoint) moveRedirectWhileCollisionP1:(CGPoint)point1 R1:(float)r1 P2:(CGPoint)point2 R2:(float)r2 Location:(CGPoint)location
{
    
    if(ccpDistance(location, point2)>r1+r2)
        return location;
    CGPoint moveVector= ccpSub(location, point1);
    CGPoint pointVector = ccpSub(point2, point1);
    
    float originalVectorAngle = [self calculateVectorAngle:moveVector.x y:moveVector.y];
    float twoPointAngle = [self calculateVectorAngle:pointVector.x y:pointVector.y];
    CGPoint resultVector = moveVector;
    
    while (true) {
        
        resultVector= [self RotatePointAboutOrigin:resultVector Angle:M_PI/36];
        CGPoint newLocation =ccpAdd(point1, resultVector);
        if(ccpDistance(newLocation, point2)>r1+r2)
            return newLocation;
    }
    
    return location;
}

+(CGPoint) RotatePointAboutOrigin:(CGPoint) point Angle:(float)angle
{
    float s = sinf(angle);
    float c = cosf(angle);
    return CGPointMake(c * point.x - s * point.y, s * point.x + c * point.y);
}

+(float) calculateVectorAngle:(float)x y:(float)y
{
    float angleRadians = atanf(x/y);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle =-1* angleDegrees;
    if (x<0) {
        cocosAngle +=180;
    }
return cocosAngle;
}

@end
