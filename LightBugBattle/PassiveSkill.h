//
//  PassiveSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/29.
//
//

#import <Foundation/Foundation.h>
#import "ActiveSkill.h"
#import "CharacterEventDelegate.h"

@interface PassiveSkill : NSObject<CharacterEventDelegate> {

}

@property (weak, nonatomic) Character *character;
@property float duration;

@end
