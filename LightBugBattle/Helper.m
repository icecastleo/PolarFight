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

+(CGPoint) CGPointRotate_Axis:(CGPoint)axis Point:(CGPoint)point Angle:(float)angle
{
    float sin = sinf(angle);
    float cos = cosf(angle);
    
    float x = ( point.x - axis.x )*cos + ( point.y - axis.y )*sin + axis.x;
    float y = ( point.x - axis.x )*sin + ( point.y - axis.y )*cos + axis.y;
    
    return ccp( x, y );
    
}

+(CGPoint) vectorFromAngle:(float) angle
{
    angle = angle * M_PI / 180;
    float sin = sinf(angle);
    float cos = cosf(angle);
    
    CGPoint point = ccp( 0, 1 );
    CGPoint axis = ccp( 0, 0 );
    float x = ( point.x - axis.x )*cos + ( point.y - axis.y )*sin + axis.x;
    float y = ( point.x - axis.x )*sin + ( point.y - axis.y )*cos + axis.y;
    
    return ccp( x, y );
}

+(float) calculateVectorAngle:(CGPoint)vector
{
    float angle = atan2f(vector.x, vector.y) * 180 / M_PI ;
	
	if( angle < 0 ) angle = 360 + angle;
	
	return angle;
}

+(CGPoint) vectorBounce_self:(CGPoint)selfPoint vector:(CGPoint)selfVector target:(CGPoint)targetPoint
{
    float N_angle = [self calculateVectorAngle:ccpSub( selfPoint, targetPoint)];
	float selfAngle = [self calculateVectorAngle:selfVector];
	
    
	float diffAngle1 = N_angle + 90 - selfAngle;
	float diffAngle2 = N_angle - 90 - selfAngle;
	
	float newAngle = 0;
	
	if( diffAngle1 < 0 ) diffAngle1 += 360;
	if( diffAngle2 < 0 ) diffAngle2 += 360;
	
	if( diffAngle1 < 180 )
	{
		newAngle = N_angle + 90 + diffAngle1;
	}
	else
	{
		newAngle = N_angle - 90 + diffAngle2;
	}
    
    if( newAngle < 0 ) newAngle += 360;
	
	return [self vectorFromAngle:newAngle];
}
@end
