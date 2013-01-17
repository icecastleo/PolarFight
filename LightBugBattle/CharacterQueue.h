//
//  CharacterQueue.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/16.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface CharacterQueueObject : NSObject
@property (weak,nonatomic) Character *character;
@property (nonatomic,readonly) NSUInteger time;
-(void)setCharacterQueueObjectTime:(NSUInteger)distance;
-(void)timeDecrease;
-(BOOL)hasTheSameCharacter:(Character *)newCharacter;
@end

@interface CharacterQueue : NSObject

-(id)initWithPlayer1Array:(NSArray *)player1 andPlayer2Array:(NSArray *)player2;

-(void)addCharacter:(Character *)newCharacter;
-(void)removeCharacter:(Character *)object;
- (Character *)pop;
- (Character *)first;
- (NSUInteger)count;
- (void)clear;

-(NSUInteger)getInsertIndexForCharacter:(Character *)newCharacter;
-(NSUInteger)getInsertIndexAndAddCharacter:(Character *)newCharacter;


@end
