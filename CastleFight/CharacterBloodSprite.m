//
//  CharacterBloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "CharacterBloodSprite.h"
#import "RenderComponent.h"
#import "TeamComponent.h"

@implementation CharacterBloodSprite

-(id)initWithEntity:(Entity *)entity {
    if (self = [super initWithEntity:entity sprite:[CCSprite spriteWithFile:@"blood_white.png"]]) {
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        NSAssert(render, @"Invalid entity!");
        
        TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        NSAssert(team, @"Invalid entity!");
        
        self.position = ccp(0, render.sprite.boundingBox.size.height/2 + self.sprite.boundingBox.size.height*1.5);
        self.midpoint = ccp(0, 0);
        self.color = team.team == kPlayerTeam ? ccc3(0, 180, 30) : ccc3(224, 32, 32);
        self.scaleX = render.sprite.boundingBox.size.width / self.sprite.boundingBox.size.width;
        self.visible = NO;
        [render.node addChild:self];
        
        CCSprite *background = [CCSprite spriteWithFile:@"blood_white.png"];
        background.position = ccp(self.sprite.boundingBox.size.width/2, self.sprite.boundingBox.size.height/2);
        background.color = ccBLACK;
        [self addChild:background z:-1];
        
        CCSprite *bloodFrame = [CCSprite spriteWithFile:@"blood_frame.png"];
        bloodFrame.position = ccp(self.sprite.boundingBox.size.width/2, self.sprite.boundingBox.size.height/2);
        bloodFrame.color = ccc3(80, 70, 60);
        [self addChild:bloodFrame];
    }
    return self;
}

-(void)update {
    [super update];
    
    [self stopAllActions];
    
    if (self.percentage == 0) {
        self.visible = NO;
    } else {
        [self runAction:[CCSequence actions:[CCShow action],
                         [CCDelayTime actionWithDuration:2.0f],
                         [CCHide action],
                         nil]];
    }
}

@end
