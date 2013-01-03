//
//  Skill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import "PositiveSkill.h"

@implementation PositiveSkill

-(void)execute {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
