//
//  CharacterQueue.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/16.
//
//

@class Character;

@protocol CharacteQueueBar <NSObject>
-(void)redrawQueueBar;
-(void)insertCharacter;
-(void)removeCharacter;
@end

@interface CharacterQueue : NSObject

@property (nonatomic) id <CharacteQueueBar> delegate;

//-(id)initWithPlayer1Array:(NSArray *)player1 andPlayer2Array:(NSArray *)player2;
-(id)initWithCharacterArrayWithRandomTime:(NSArray *)characters;
-(void)addCharacter:(Character *)newCharacter;
-(void)removeCharacter:(Character *)object;
- (Character *)pop;
- (NSUInteger)count;
- (void)clear;

-(NSUInteger)getInsertIndexForCharacter:(Character *)newCharacter;
-(NSArray *)currentCharacterQueueArray;

@end
