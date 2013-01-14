//
//  RangeCarrier.h
//  LightBugBattle
//
//  Created by 陳 謙 on 13/1/14.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActiveSkill.h"
@class  Character;
@class Range;
@interface RangeCarrier : CCSprite
{
    Range *carryRange;
    NSString *IconFileName;
    CGPoint shootVector;
    Character *character;
    id delegate;
    
    CGPoint startPoint;
    
    float distance;
}


-(id)init:(Range *)range iconFileName:(NSString *)icon;
-(void) shoot:(CGPoint)vector speed:(float) speed delegate:(id)delegate;
@end
