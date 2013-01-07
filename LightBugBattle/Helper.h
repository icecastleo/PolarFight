//
//  Helper.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Helper : NSObject {
    
}
+(CGPoint) moveRedirectWhileCollisionP1:(CGPoint)point1 R1:(float)r1 P2:(CGPoint)point2 R2:(float)r2 Location:(CGPoint)location;
+(CGPoint) CGPointRotate_Axis:(CGPoint)axis Point:(CGPoint)point Angle:(float)angle;
+(CGPoint) vectorBounce_self:(CGPoint)selfPoint vector:(CGPoint)selfVector target:(CGPoint)targetPoint;
+(float) calculateVectorAngle:(CGPoint)vector;
+(CGPoint) vectorFromAngle:(float) angle;
@end
