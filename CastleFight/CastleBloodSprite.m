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

@interface CastleBloodSprite() {
    // Just for vibrate
    BOOL vibrate;
    double lastUpdate;
}

@end

@implementation CastleBloodSprite

-(id)initWithEntity:(Entity *)entity {
    TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    NSAssert(team, @"Invalid entity!");
        
    if (self = [super initWithEntity:entity sprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"gauge%02d.png", team.team]]]) {
        self.midpoint = ccp(team.team == kPlayerTeam ? 1 : 0, 0);
        
        vibrate = team.team == kPlayerTeam ? YES : NO;
    }
    return self;
}

-(void)update {
    [super update];
    
    if (vibrate) {
        if (lastUpdate + 5 < CACurrentMediaTime()) {
            // [[SimpleAudioEngine sharedEngine] vibrate];
        }
        lastUpdate = CACurrentMediaTime();
    }
}

@end
