//
//  Party.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/10.
//
//

#import "Party.h"
#import "Character.h"

@implementation Party

- (id)init {
    
    if ((self = [super init])) {
        self.players = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
    
}

- (void) dealloc {
    self.players = nil;
    [super dealloc];
}

- (Character *)characterFromName:(NSString *)name player:(int)pNumber
{
    for (Character *role in self.players) {
        if ([role.name isEqualToString:name]) {
            return role;
        }
    }
    return nil;
}

- (NSArray *)characterFromPlayer:(int)pNumber
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Character *role in self.players) {
        if (role.player == pNumber) {
            [array addObject:role];
        }
    }
    return array;
}

@end
