//
//  CastleBloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "CastleBloodSprite.h"
#import "Character.h"

@implementation CastleBloodSprite

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter sprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"gauge%02d.png",aCharacter.player]]]) {
        self.midpoint = ccp(aCharacter.player == 1 ? 1 : 0, 0);
        [self update];
    }
    return self;
}

@end
