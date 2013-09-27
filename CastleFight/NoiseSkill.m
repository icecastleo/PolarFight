//
//  NoiseSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "NoiseSkill.h"
#import "AttackEvent.h"
#import "ProjectileComponent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "AttackerComponent.h"

@implementation NoiseSkill

-(void)setOwner:(Entity *)owner {
    RenderComponent *render = (RenderComponent *)[owner getComponentOfName:[RenderComponent name]];
    int width = render.sprite.boundingBox.size.width*10;
    int height = render.sprite.boundingBox.size.height*5;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    range = [Range rangeWithParameters:dictionary];
    
    [super setOwner:owner];
    
    self.cooldown = 2;
}

-(void)activeEffect {
    //TODO: Noise RangeAttack. 

}

@end
