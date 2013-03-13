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
    if (self = [super initWithCharacter:aCharacter sprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"blood_%@.png",aCharacter.player == 1 ? @"green" : @"red"]]]) {
        self.position = ccp(character.boundingBox.size.width / 2, character.boundingBox.size.height + self.sprite.boundingBox.size.height * 1.5);
        self.midpoint = ccp(0, 0);
        self.scaleX = character.boundingBox.size.width / self.sprite.boundingBox.size.width;
        self.visible = NO;
        [self update];
        [character.sprite addChild:self];
        
        CCSprite *bloodFrame = [CCSprite spriteWithFile:@"blood_frame.png"];
        bloodFrame.position = ccp(self.sprite.boundingBox.size.width / 2, self.sprite.boundingBox.size.height / 2);
        [self addChild:bloodFrame];
    }
    return self;
}

@end
