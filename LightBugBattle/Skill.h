//
//  Skill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import <Foundation/Foundation.h>
#import "EffectKit.h"

@interface Skill : NSObject {
    Character *owner;
}

@property (retain) Character *owner;

@end
