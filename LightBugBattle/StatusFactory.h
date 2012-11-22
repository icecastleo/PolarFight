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
#import "TimeStatus.h"
#import "AuraStatus.h"

@interface StatusFactory : NSObject

+(TimeStatus*)createTimeStatus:(TimeStatusType)type withTime:(int)time toCharacter:(Character*)character;
+(AuraStatus*)createAuraStatus:(AuraStatusType)type withCaster:(Character *)caster;

@end
