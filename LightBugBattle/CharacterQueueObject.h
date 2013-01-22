//
//  CharacterQueueObject.h
//  LightBugBattle
//
//  Created by  DAN on 13/1/18.
//
//

@class Character;

@interface CharacterQueueObject : NSObject

@property (weak,nonatomic) Character *character;
@property (nonatomic,readonly) NSUInteger time;

-(void)setCharacterQueueObjectTime:(NSUInteger)distance;
-(void)timeDecrease:(NSUInteger)number;
-(BOOL)hasTheSameCharacter:(Character *)newCharacter;

-(void)setCharacterQueueObjectTimeWithaVariable:(NSUInteger)distance;

@end
