//
//  RangeCarrier.m
//  LightBugBattle
//
//  Created by 陳 謙 on 13/1/14.
//
//

#import "RangeCarrier.h"
#import "Character.h"
#import "BattleController.h"
@implementation RangeCarrier

-(id)init:(Range *)range iconFileName:(NSString *)icon
{
    if (self = [super initWithFile:icon]) {
        carryRange = range;
      
        character = range.character;
        [character.sprite.parent addChild:self];
        
        self.position = character.position;
    }
    return self;
}

-(void)shoot:(CGPoint)vector speed:(float)speed delegate:(id)dele
{
//    NSLog(@"shoot");
    float angle = atan2f(vector.y, vector.x);
    delegate = dele;
    
    float angleDegrees = CC_RADIANS_TO_DEGREES(angle);
    float cocosAngle = -1 * angleDegrees;
    
    self.rotation = cocosAngle;
    shootVector = ccpMult(vector, speed);
    startPoint = self.position;
    [self schedule:@selector(update:)];
}

-(void)update:(ccTime)delta
{
    if(ccpDistance(self.position, startPoint) > 200)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
    }
    
    self.position = ccpAdd(self.position, shootVector);
    
    [self checkCollision];
}

-(void)checkCollision
{
    NSMutableArray *effectTargets = [NSMutableArray array];
    
    for(Character* target in [BattleController currentInstance].characters)
    {
        if (![self checkSide:target]) {
            continue;
        }
        
        if ([self checkFilter:target]) {
            continue;
        }
        
        if (CGRectIntersectsRect(self.boundingBox, target.boundingBox)) {
            [effectTargets addObject:target];
        }
    }
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(delayExecute:carrier:)]) {
            [delegate delayExecute:effectTargets carrier:self];
        }
        
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
    }
}

-(BOOL)checkSide:(Character *)temp {
    if ([carryRange.sides containsObject:kRangeSideAlly]) {
        if (temp.player == character.player) {
            return YES;
        }
    }
    
    if ([carryRange.sides containsObject:kRangeSideEnemy]) {
        if (temp.player != character.player) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkFilter:(Character *)temp {
    if (carryRange.filters == nil) {
        return NO;
    }
    
    if ([carryRange.filters containsObject:kRangeFilterSelf]) {
        if (temp == character) {
            return YES;
        }
    }
    return NO;
}

@end
