//
//  Armor.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/6.
//
//

#import "Armor.h"

@implementation Armor

-(id)initWithArmorType:(int)aType {
    if(self = [super init]) {
        type = aType;
    }
    return self;
}

-(void)setCharacter:(Character *)character {
    // TODO: Maybe add some defense or?
    
    // TODO: Handle strengths and weaknesses?
}

@end
