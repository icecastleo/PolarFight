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
        carryRange=range;
      
        character=range.character;
        [character.sprite.parent addChild:self];
        
        self.position =character.position;// ccp(character.sprite.boundingBox.size.width/2,character.sprite.boundingBox.size.height/2);
        
    }

    
    return self;
}

-(void) shoot:(CGPoint)vector speed:(float) speed delegate:(id)dele
{
    NSLog(@"shoot");
    float angle = atan2f(vector.y, vector.x);
    delegate=dele;
    
    float angleDegrees = CC_RADIANS_TO_DEGREES(angle);
    float cocosAngle = -1 * angleDegrees;
    
    self.rotation = cocosAngle;
    shootVector=CGPointMake(speed*cos(angle), speed*sin(angle));
    startPoint=self.position;
    [self schedule:@selector(spidersUpdate:) interval:0.1];
}

-(void) checkCollision
{
    NSMutableArray *effectTargets = [NSMutableArray array];
    CGRect playerRect = CGRectMake(self.position.x - (self.contentSize.width/2),
                                   self.position.y - (self.contentSize.height/2),
                                   self.contentSize.width,
                                   self.contentSize.height);
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if (![self checkSide:temp]) {
            continue;
        }
        
        if ([self checkFilter:temp]) {
            continue;
        }
        CGRect targetRect = CGRectMake(temp.position.x - (temp.sprite.contentSize.width/2),
                                       temp.position.y - (temp.sprite.contentSize.height/2),
                                       temp.sprite.contentSize.width,
                                       temp.sprite.contentSize.height);
        
       
        if (  CGRectIntersectsRect(playerRect,targetRect)) {
            [effectTargets addObject:temp];
        }
    
    }
    if(effectTargets.count>0){
       
            SEL x = NSSelectorFromString(@"delayExecute:carrier:");
       
        [delegate performSelector:x withObject:effectTargets withObject:self];
        
        
        [self unschedule:@selector(spidersUpdate:)];
        [character.sprite.parent removeChild:self cleanup:YES];
    }
}
-(void) spidersUpdate:(ccTime)delta
{
    
    if(ccpDistance(self.position, startPoint)>200)
    {
        [self unschedule:@selector(spidersUpdate:)];
        [character.sprite.parent removeChild:self cleanup:YES];
        
    }
    
    [self checkCollision];
    
    CGPoint belowScreenPosition =
    CGPointMake(self.position.x+shootVector.x, self.position.y+shootVector.y);
    
    CCMoveTo* move = [CCMoveTo actionWithDuration:0.3 position:belowScreenPosition];
    
    //CCCallFuncN* call = [CCCallFuncN actionWithTarget:self selector:@selector(spiderBelowScreen:)];
    
    CCSequence* sequnece = [CCSequence actions:move, nil];
    [self runAction:sequnece];
    
}

-(void) spiderBelowScreen:(id)sender
{
    NSAssert([sender isKindOfClass:[CCSprite class]], @"sender is not a CCSprite!");
    CCSprite* spider = (CCSprite*)sender;
    
    CGPoint pos =    CGPointMake(self.position.x+shootVector.x, self.position.y+shootVector.x);
    spider.position=pos;
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

-(void) dealloc
{
    NSLog(@"dealloc");
}

@end
