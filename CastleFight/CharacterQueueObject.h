//
//  CharacterQueueObject.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/18.
//
//

@class Character;

@interface CharacterQueueObject : NSObject

@property (weak) Character *character;
@property (readonly) NSUInteger time;

-(void)setCharacterQueueObjectTime;
-(void)timeDecrease:(NSUInteger)number;
-(BOOL)hasTheSameCharacter:(Character *)newCharacter;

-(void)setCharacterQueueObjectTimeWithaVariable;

@end
