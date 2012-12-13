//
//  EffectType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//
//

#import "Effect.h"

@implementation Effect

-(void)doEffectFromCharacter:(Character *)aCharacter toCharacter:(Character *)bCharacter {
    [NSException raise:@"Called abstract method!" format:@"You have to override doEffect method."];
}
@end
