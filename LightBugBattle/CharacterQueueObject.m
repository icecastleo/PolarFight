//
//  CharacterQueueObject.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/18.
//
//

#import "CharacterQueueObject.h"
#import "Character.h"

@implementation CharacterQueueObject

static const int distance = NSUIntegerMax;
static const double a = 0.03;
static const double b = -3.75;
static const double c = 135;


-(void)setCharacterQueueObjectTime {
    int agile = [self.character getAttribute:kCharacterAttributeAgile].value;
    //old function
//    _time = distance/agile;
    
    //new (testing)
    _time = [self agileToTimeFunction:agile];
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
-(void)setCharacterQueueObjectTimeWithaVariable {
    //random add/minus a half of agile to this character in this time.
    int agile = [self.character getAttribute:kCharacterAttributeAgile].value;
    int pickaNumber = arc4random() % 2;
    int variable = 1;
    
    if (pickaNumber != 0)
        variable *= -1;
    
      //old function
//    _time = distance/(agile+variable);
    _time = [self agileToTimeFunction:(agile+variable)];
}

-(NSUInteger)agileToTimeFunction:(NSUInteger)agile {
    double doubleTime = a * agile*agile + b * agile + c;
    NSUInteger time = floor(doubleTime);
    return time;
}

@end
