//
//  CharacterQueueObject.m
//  LightBugBattle
//
//  Created by  DAN on 13/1/18.
//
//

#import "CharacterQueueObject.h"
#import "Character.h"

@implementation CharacterQueueObject
@synthesize time = _time;

-(void)setCharacterQueueObjectTime:(NSUInteger)distance {
    int agile = [self.character getAttribute:kCharacterAttributeAgile].value;
    _time = distance/agile;
}
-(void)timeDecrease {
    if (self.time > 1) {
        _time--;
    }else {
        _time = 0;
    }
}
-(BOOL)hasTheSameCharacter:(Character *)newCharacter {
    if (self.character == newCharacter) {
        return YES;
    }
    return NO;
}
@end
