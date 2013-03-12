//
//  BloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "BloodSprite.h"
#import "Character.h"

@implementation BloodSprite

-(id)initWithCharacter:(Character *)aCharacter sprite:(CCSprite *)sprite {
    if (self = [super initWithSprite:sprite]) {
        character = aCharacter;
        
        self.type = kCCProgressTimerTypeBar;
        self.barChangeRate = ccp(1, 0);
    }
    return self;
}

-(void)update {
    Attribute *hp = [character getAttribute:kCharacterAttributeHp];
    
    NSAssert(hp != nil, @"Why you need a blood sprite on a character without hp?");
    
    float scale = (float) hp.currentValue / hp.value;
    
    self.percentage = scale * 100;
}

@end
