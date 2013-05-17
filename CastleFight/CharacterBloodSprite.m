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
        RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
        NSAssert(render, @"Invalid entity!");
        
        TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
        NSAssert(team, @"Invalid entity!");
        
        CCSprite *sprite = render.sprite;
        
        self.position = ccp(sprite.boundingBox.size.width / 2, sprite.boundingBox.size.height + self.sprite.boundingBox.size.height * 1.5);
        self.midpoint = ccp(0, 0);
        self.color = team.team == 1 ? ccc3(0, 180, 30) : ccc3(224, 32, 32);
        self.scaleX = sprite.boundingBox.size.width / self.sprite.boundingBox.size.width;
        self.visible = NO;
        [sprite addChild:self];
        
        CCSprite *background = [CCSprite spriteWithFile:@"blood_white.png"];
        background.position = ccp(self.sprite.boundingBox.size.width / 2, self.sprite.boundingBox.size.height / 2);
        background.color = ccBLACK;
        [self addChild:background z:-1];
        
        CCSprite *bloodFrame = [CCSprite spriteWithFile:@"blood_frame.png"];
        bloodFrame.position = ccp(self.sprite.boundingBox.size.width / 2, self.sprite.boundingBox.size.height / 2);
        bloodFrame.color = ccc3(80, 70, 60);
        [self addChild:bloodFrame];
    }
    return self;
}

@end
