//
//  CharacterQueueLayer.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/17.
//
//

#import "cocos2d.h"
#import "CharacterQueue.h"
#import "SWTableView.h"

@interface CharacterQueueLayer : CCLayer <CharacteQueueBar,SWTableViewDataSource,SWTableViewDelegate>

@property (weak, nonatomic) Character *currentCharacter;

-(id)initWithQueue:(CharacterQueue *)aQueue;

@end
