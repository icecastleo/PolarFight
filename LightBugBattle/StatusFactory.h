//
//  StatusFactory.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/8.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "Character.h"
#import "Status.h"

@interface StatusFactory : NSObject

+(Status*)createTimeStatus:(StatusType)type onCharacter:(Character*) character withTime:(int)time;
+(Status*)createAuraStatus:(StatusType)type onCharacter:(Character*) character withCaster:(Character *)caster;

@end
