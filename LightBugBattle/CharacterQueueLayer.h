//
//  CharacterQueueLayer.h
//  LightBugBattle
//
//  Created by  DAN on 13/1/17.
//
//

#import "cocos2d.h"
#import "CharacterQueue.h"

@interface CharacterQueueLayer : CCLayer <CharacteQueueBar>

@property (weak,nonatomic) Character *currentCharacter;

-(id)initWithQueue:(CharacterQueue *)aQueue;

@end
