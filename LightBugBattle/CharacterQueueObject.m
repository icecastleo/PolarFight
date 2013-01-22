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
-(void)setCharacterQueueObjectTimeWithaVariable:(NSUInteger)distance {
    //random add/minus a half of agile to this character in this time.
    int agile = [self.character getAttribute:kCharacterAttributeAgile].value;
    int pickaNumber = arc4random() % 2;
    int variable = agile/2;
    
    if (pickaNumber != 0)
        variable *= -1;
        
    _time = distance/(agile+variable);
}
@end
