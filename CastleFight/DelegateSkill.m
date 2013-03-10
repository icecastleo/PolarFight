//
//  DelegateSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/11.
//
//

#import "DelegateSkill.h"
#import "Character.h"

@implementation DelegateSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
    }
    return self;
}

-(void)effectTarget:(Character *)target atPosition:(CGPoint)position {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

@end
