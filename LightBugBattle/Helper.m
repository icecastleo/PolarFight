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
    
    
    CGPoint clockWiseNew =location;
    CGPoint counterClockWiseNew =location;
   
    CGPoint resultVector = moveVector;
    int i  = 0;
    int j =0;
    for(;i<10;i++)
    {
        resultVector= [self RotatePointAboutOrigin:resultVector Angle:M_PI/36];
        clockWiseNew =ccpAdd(point1, resultVector);
        if(ccpDistance(clockWiseNew, point2)>r1+r2)
            break;
    }
    resultVector = moveVector;
    for(;j<10;j++)
    {
        resultVector= [self RotatePointAboutOrigin:resultVector Angle:M_PI/36*-1];
        counterClockWiseNew =ccpAdd(point1, resultVector);
        if(ccpDistance(counterClockWiseNew, point2)>r1+r2)
            break;
    }
    if(i+j==20)
        return point1;
    if(ccpDistance(location, counterClockWiseNew)<ccpDistance(location, clockWiseNew))
        return counterClockWiseNew;
    else
        return clockWiseNew;
    
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
