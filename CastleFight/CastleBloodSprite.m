//
//  CastleBloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "CastleBloodSprite.h"
#import "TeamComponent.h"
#import "DefenderComponent.h"

@implementation CastleBloodSprite

-(id)initWithEntity:(Entity *)entity {
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    NSAssert(team, @"Invalid entity!");
        
    if (self = [super initWithEntity:entity sprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"gauge%02d.png", team.team]]]) {
        self.midpoint = ccp(team.team == 1 ? 1 : 0, 0);
    }
    return self;
}

@end
