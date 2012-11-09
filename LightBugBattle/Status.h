//
//  CharacterStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "Character.h"

// TODO: name & imgFile;
@interface Status : NSObject {
    StatusType *type;
    Character *character;
    NSString *name;
    NSString *imgFile;
}

-(id) initWithCharacter:(Character *) cha;

-(void) addEffect;
-(void) removeEffect;

-(void) update;

@end
