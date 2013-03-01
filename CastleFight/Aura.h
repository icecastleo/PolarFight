//
//  Aura.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "ActiveSkill.h"

@interface Aura : CCNode {
    Range *range;
    __weak Character *character;
}

-(id)initWithCharacter:(Character *)aCharacter;
-(NSMutableDictionary *)getRangeDictionary;
-(void)execute:(Character *)target;

@end
