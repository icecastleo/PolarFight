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
-(void)insertCharacterAtIndex:(NSUInteger)index withAnimated:(BOOL)animated;
-(void)removeCharacter:(Character *)character withAnimated:(BOOL)animated;
@end

@interface CharacterQueue : NSObject

@property id<CharacteQueueBar> delegate;
@property (readonly) int count;

//-(id)initWithPlayer1Array:(NSArray *)player1 andPlayer2Array:(NSArray *)player2;
-(id)initWithCharacterArrayWithRandomTime:(NSArray *)characters;
-(void)addCharacter:(Character *)newCharacter;
-(void)removeCharacter:(Character *)character withAnimated:(BOOL)animated;
-(Character *)pop;

-(NSArray *)currentCharacterQueueArray;

@end
