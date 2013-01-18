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
-(void)timeDecrease;
-(BOOL)hasTheSameCharacter:(Character *)newCharacter;

@end
