//
//  CharacterBloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "CharacterBloodSprite.h"
#import "Character.h"

@implementation CharacterBloodSprite

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter sprite:[CCSprite spriteWithFile:@"blood_white.png"]]) {
        self.position = ccp(character.boundingBox.size.width / 2, character.boundingBox.size.height + self.sprite.boundingBox.size.height * 1.5);
        self.midpoint = ccp(0, 0);
        self.color = aCharacter.player == 1 ? ccc3(0, 180, 30) : ccc3(224, 32, 32);
        self.scaleX = character.boundingBox.size.width / self.sprite.boundingBox.size.width;
        self.visible = NO;
        [self update];
        [character.sprite addChild:self];
        
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
