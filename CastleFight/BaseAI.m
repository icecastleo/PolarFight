//
//  BaseAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import "BaseAI.h"

@implementation BaseAI
@synthesize character;


-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        aiState=Walking;
    }
    return self;
}

-(void)AIUpdate {
        [NSException raise:NSInternalInconsistencyException
                   format:@"You must override %@ in a AI subclass", NSStringFromSelector(_cmd)];
}

@end
