//
//  KnockOutObject.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@interface KnockOutObject : NSObject {

}

@property (readonly) Character *character;
@property (readwrite) CGPoint velocity;
@property (readwrite) float power;
@property (readonly) BOOL collision;

@property (readwrite) int count;
@property (readwrite) float ratio;

@property (readonly) int maxCount;
@property (readonly) float acceleration;

-(id)initWithCharacter:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision;

@end
