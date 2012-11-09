//
//  AuraStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "Status.h"
#import "RangeType.h"

@interface AuraStatus : Status {
    Character *caster;
    RangeType *range;
}

-(id)initWithCharacter:(Character *)cha caster:(Character *)cas;

@end
