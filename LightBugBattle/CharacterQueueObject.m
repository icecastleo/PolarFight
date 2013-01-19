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
-(void)timeDecrease:(NSUInteger)number {
    if (self.time > 0 && number <= 0) {
        _time--;
    }else if (self.time < number) {
        _time = 0;
    }else if (self.time <= 0) {
        _time = 0;
    }else {
        _time -= number;
    }
}
-(BOOL)hasTheSameCharacter:(Character *)newCharacter {
    if (self.character == newCharacter) {
        return YES;
    }
    return NO;
}
@end
