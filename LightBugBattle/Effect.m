//
//  EffectType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//
//

#import "Effect.h"
#import "Character.h"

@implementation Effect

-(void) doEffect:(Character *)character {
    [NSException raise:@"Called abstract method!" format:@"You have to override doEffect method."];
}
@end
